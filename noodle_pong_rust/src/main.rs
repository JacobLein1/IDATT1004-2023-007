extern crate ev3dev_lang_rust;

use ev3dev_lang_rust::motors::{LargeMotor, MotorPort};
use ev3dev_lang_rust::sensors::{SensorPort, TouchSensor};
use ev3dev_lang_rust::Ev3Result;
use serde_json::*;
use std::hash::BuildHasher;
use std::io;
use std::io::prelude::*;
use std::io::BufReader;
use std::net::{TcpListener, TcpStream};

mod constants;
use constants::*;

fn main() -> Ev3Result<()> {
    // let motor_right = LargeMotor::get(MotorPort::OutD)?;
    // let motor_left = LargeMotor::get(MotorPort::OutC)?;
    // let press_sensor = TouchSensor::get(SensorPort::In1)?;

    let listener = TcpListener::bind(format!("{}:{}", IP_ADDRESS, PORT))?;

    for stream in listener.incoming() {
        handle_connection(stream.unwrap()).unwrap();
        ev3dev_lang_rust::sound::beep().unwrap();
        println!("incoming")

    }

    Ok(())
}

fn handle_connection(mut stream: TcpStream) -> io::Result<()> {
    let mut buffer = [0; 1024];
    stream.read(&mut buffer)?;
    stream.write(&buffer[..])?;
    stream.flush()?;
    Ok(())
}

const OK: &str = "HTTP/1.1 200 OK\r\n\r\n";
