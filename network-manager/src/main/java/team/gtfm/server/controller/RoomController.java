package team.gtfm.server.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import team.gtfm.server.bean.Room;
import team.gtfm.server.bean.UpdateResult;

@RestController
public class RoomController {
	private final String contentType = "application/json; charset=utf-8";
	
	@RequestMapping(value="/data/room", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertRoom(@RequestBody Room room){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room/{roomName}", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Room> getRoom(@PathVariable String roomName){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room/{roomName}", 
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteRoom(@PathVariable String roomName){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room", 
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> putRoom(@RequestBody Room room){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
