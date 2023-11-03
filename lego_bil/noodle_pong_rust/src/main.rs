extern crate ev3dev_lang_rust;

use ev3dev_lang_rust::motors::{LargeMotor, MotorPort};
use ev3dev_lang_rust::sensors::{SensorPort, TouchSensor};
use ev3dev_lang_rust::Ev3Result;
use serde_json::*;
use std::io::BufReader;
use std::net::{TcpListener, TcpStream};

fn main() -> Ev3Result<()> {
    let motor_right = LargeMotor::get(MotorPort::OutD)?;
    let motor_left = LargeMotor::get(MotorPort::OutC)?;
    let press_sensor = TouchSensor::get(SensorPort::In1)?;

    let listener = TcpListener::bind("127.0.0.1:7878")?;

    for stream in listener.incoming() {
        handle_connection(stream.unwrap());

        println!("Connection established!");
    }

    Ok(())
}

fn handle_connection(mut stream: TcpStream) {
    let buf_reader = BufReader::new(&mut stream);
    let http_request: Vec<_> = buf_reader
        .lines()
        .map(|result| result.unwrap())
        .take_while(|line| !line.is_empty())
        .collect();

    println!("Request: {:#?}", http_request);
}

#[derive(Serialize, Deserialize)]
struct AdjustemtRequest {
    power: float32,
    horizontal: float32,
}
