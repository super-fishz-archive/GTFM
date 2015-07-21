package team.gtfm.server.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import team.gtfm.server.bean.Room;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.RoomDao;

@RestController
public class RoomController {
	private final String contentType = "application/json; charset=utf-8";
	
	@Autowired
	private RoomDao dao;
	
	@RequestMapping(value="/data/room", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertRoom(@RequestBody Room room){
		
		int c = dao.insertRoom(room);
		UpdateResult result = new UpdateResult();
		result.setResult(c);
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room/{seq}", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Room> getRoom(@PathVariable String seq){
		
		Room room = dao.selectRoom(Integer.parseInt(seq));
		return new ResponseEntity<>(room, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<List<Room>> getRoomAll(){
		List<Room> list = dao.selectRoomAll();
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room/{seq}", 
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteRoom(@PathVariable String seq){
		
		int c = dao.deleteRoom(Integer.parseInt(seq));
		return new ResponseEntity<>(UpdateResult.create(c), HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/room", 
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> putRoom(@RequestBody Room room){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
