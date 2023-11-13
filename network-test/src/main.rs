use std::{net::TcpListener, io::{Write, Read}};

use ev3dev_lang_rust::{self as ev3, Ev3Result};

fn main() -> Ev3Result<()> {
    let ip = "192.168.137.11";

    let listener = TcpListener::bind(format!("{}:7878", ip)).unwrap();

    for stream in listener.incoming() {
        let mut stream = stream.unwrap();
        ev3::sound::beep()?;
        let mut buffer = [0; 1024];
        stream.read(&mut buffer).unwrap();
        stream.write(b"HTTP/1.1 200 OK").unwrap();
        stream.flush().unwrap();
    };
    Ok(())
}
