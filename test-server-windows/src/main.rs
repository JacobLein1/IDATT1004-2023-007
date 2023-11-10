use std::io::prelude::*;
use std::net::{TcpListener, TcpStream};

use serde::{Deserialize, Serialize};
use serde_json;

fn main() {

    let listener = TcpListener::bind(format!("0.0.0.0:3000")).unwrap();

    for stream in listener.incoming() {
        println!("incoming");
        handle_connection(stream.expect("the supplied iterator should be infinite"));
    }
}

fn handle_connection(mut stream: TcpStream) {
    let mut buffer = [0; 1024];
    stream.read(&mut buffer).unwrap();

    let body = buffer
        .split(|e| *e == b'\n')
        .last().unwrap()
        .into_iter()
        .filter_map(|b| if *b == 0 {None} else {Some(*b)})
        .collect::<Vec<_>>();

    let mut command = Command::None;
    let response = if buffer.starts_with(b"POST /adjust") {
        if let Ok(_adjust) = serde_json::from_slice::<Adjustment>(&body[..]) {
            // TODO: adjust
            OK
        } else {
            BAD_REQUEST
        }
    } else if buffer.starts_with(b"POST /fire") {
        // TODO: fire
        OK
    } else {
        NOT_FOUND
    };

    stream.write(&response[..]).unwrap();
    stream.flush().unwrap();
}

const OK: &[u8] = b"HTTP/1.1 200 OK\r\n\r\n";
const NOT_FOUND: &[u8] = b"HTTP/1.1 404 NOT FOUND\r\n\r\n";
const BAD_REQUEST: &[u8] = b"HTTP/1.1 400 BAD REQUEST\r\n\r\n";


#[derive(Serialize, Deserialize)]
struct Adjustment {
    x: f64,
    force: f64
}