extern crate ev3dev_lang_rust;

use ev3dev_lang_rust::motors::{LargeMotor, MotorPort};
use ev3dev_lang_rust::sensors::{SensorPort, TouchSensor};
use ev3dev_lang_rust::Ev3Result;
use serde_json::*;
use std::io::BufReader;
use std::io;
use std::io::prelude::*;
use std::net::{TcpListener, TcpStream};

use constants::*;

fn main() -> Ev3Result<()> {
    let motor_right = LargeMotor::get(MotorPort::OutD)?;
    let motor_left = LargeMotor::get(MotorPort::OutC)?;
    let press_sensor = TouchSensor::get(SensorPort::In1)?;

    let listener = TcpListener::bind(IP_ADDRESS + ":" + PORT)?;

    for stream in listener.incoming() {
        handle_connection(stream.unwrap());

        println!("Connection established!");
    }

    Ok(())
}

fn handle_connection(mut stream: TcpStream) -> io::Result<()> {
    let mut buffer = [0; 1024];
    let request = stream.read(&mut buffer)?;
    dbg!(request);
    stream.write(OK.as_bytes())?;
    stream.flush()?;
    Ok(())
}

const OK: &str = "HTTP/1.1 200 OK\r\n\r\n";