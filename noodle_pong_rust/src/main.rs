use std::sync::Arc;
use std::thread;
use std::time::Duration;

use ev3dev_lang_rust::motors::{LargeMotor, MediumMotor, MotorPort, TachoMotor};
use ev3dev_lang_rust::Ev3Result;
use serde::{Deserialize, Serialize};
use serde_json;

use tokio::io::*;
use tokio::net::{TcpListener, TcpStream};

mod constants;
use constants::*;

#[tokio::main]
async fn main() -> Ev3Result<()> {
    let motor_right = Arc::new(LargeMotor::get(MotorPort::OutA)?);
    let motor_left = Arc::new(LargeMotor::get(MotorPort::OutB)?);
    let rotator = Arc::new(TachoMotor::get(MotorPort::OutD)?);
    let feeder = Arc::new(MediumMotor::get(MotorPort::OutC)?);
    /*
    motor_left.set_stop_action("brake")?;
    motor_right.set_stop_action("brake")?;
    rotator.set_stop_action("brake")?;
    feeder.set_stop_action("brake")?;
    */

    let listener = TcpListener::bind(format!("{}:{}", IP_ADDRESS, PORT)).await?;

    loop {
        let (mut stream, _) = listener.accept().await.unwrap();

        let (req, res) = parse_request(&mut stream).await;

        stream.write(res.as_bytes()).await.unwrap();
        stream.flush().await.unwrap();

        match req {
            Request::Adjust(adj) => {
                println!("adjust");
                let Adjustment { x, force } = adj;
                println!("Force: {force}, rotation: {x}");
                // let x = dir_map(x);
                let force = -force_map(force);
                motor_left.set_duty_cycle_sp(force)?;
                motor_right.set_duty_cycle_sp(force)?;
                // motor_left.run_direct()?;
                // motor_right.run_direct()?;
                // motor_left.stop()?;
                // motor_right.stop()?;
                rotator.set_speed_sp(200)?;
                let tacos = (rotator.get_count_per_rot()? as f64 * (1.0 / 8.0) * (x)) as i32;
                println!("tacos: {}", tacos);
                rotator.run_to_rel_pos(Some(tacos))?;
                // rotator.run_to_abs_pos(Some(x))?;
                // rotator.wait_until_not_moving(Some(TIMEOUT));
            }
            Request::Fire => {
                println!("fire");
                ev3dev_lang_rust::sound::beep().unwrap();
                motor_left.run_direct()?;
                motor_right.run_direct()?;
                feeder.set_speed_sp(275)?;
                feeder.run_to_rel_pos(Some(1500))?;
                feeder.wait_until_not_moving(None);
                motor_left.stop()?;
                motor_right.stop()?;
                feeder.run_to_rel_pos(Some(-1500))?;
            }
            Request::Calibrate => {
                feeder.set_speed_sp(100)?;
                feeder.run_to_abs_pos(Some(0))?;
            }
            Request::None => {}
        }
    }
}

async fn parse_request(stream: &mut TcpStream) -> (Request, &'static str) {
    let mut buffer = [0; 1024];
    stream.read(&mut buffer).await.unwrap();

    let body = buffer
        .split(|e| *e == b'\n')
        .last()
        .unwrap()
        .into_iter()
        .filter_map(|b| if *b == 0 { None } else { Some(*b) })
        .collect::<Vec<_>>();

    let (req, res) = if buffer.starts_with(b"POST /adjust") {
        (
            Request::Adjust(serde_json::from_slice::<Adjustment>(&body[..]).unwrap()),
            OK,
        )
    } else if buffer.starts_with(b"POST /fire") {
        (Request::Fire, OK)
    } else if buffer.starts_with(b"POST /calibrate") {
        (Request::Calibrate, OK)
    } else {
        (Request::None, OK)
    };
    (req, res)
}

const OK: &str = "HTTP/1.1 200 OK\r\n\r\n";
const NOT_FOUND: &str = "HTTP/1.1 404 NOT FOUND\r\n\r\n";
const BAD_REQUEST: &str = "HTTP/1.1 400 BAD REQUEST\r\n\r\n";

const TIMEOUT: Duration = Duration::from_secs(3);

#[derive(Serialize, Deserialize)]
struct Adjustment {
    x: f64,
    force: f64,
}

enum Request {
    Adjust(Adjustment),
    Fire,
    Calibrate,
    None,
}

fn dir_map(x: f64) -> i32 {
    (x * 45.00) as i32
}

fn force_map(force: f64) -> i32 {
    (force * 99.00) as i32
}
