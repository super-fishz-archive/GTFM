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

import team.gtfm.server.bean.Port;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.NetworkManagerDao;

@RestController
public class PortController {
	private final String CONTENT_TYPE = "application/json; charset=utf-8";
	
	@Autowired
	private NetworkManagerDao networkManagerDao;
	
	@RequestMapping(value="/data/port", 
			method=RequestMethod.POST,
			consumes=CONTENT_TYPE,
			produces=CONTENT_TYPE)
	public ResponseEntity<UpdateResult> insertBuilding(@RequestBody Port port){
		int c = networkManagerDao.insertPort(port);
		UpdateResult result = new UpdateResult();
		result.setResult((c > 0)? true : false);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/port/{seq}",
			method=RequestMethod.GET,
			produces=CONTENT_TYPE)
	public ResponseEntity<Port> getBuildings(@PathVariable String seq){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/port",
			method=RequestMethod.GET,
			produces=CONTENT_TYPE)
	public ResponseEntity<List<Port>> getBuildingsAll(){
		
		List<Port> list = networkManagerDao.selectPortAll();
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/port/{seq}",
			method=RequestMethod.DELETE,
			produces=CONTENT_TYPE)
	public ResponseEntity<UpdateResult> deleteBuilding(@PathVariable String seq){
		int c = networkManagerDao.deletePort(Integer.parseInt(seq));
		UpdateResult result = new UpdateResult();
		result.setResult((c > 0)? true : false);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="data/port",
			method=RequestMethod.PUT,
			consumes=CONTENT_TYPE,
			produces=CONTENT_TYPE)
	public ResponseEntity<UpdateResult> updateBuilding(@RequestBody Port port){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="data/port/not-using-ip",
			method=RequestMethod.GET,
			produces=CONTENT_TYPE)
	public ResponseEntity<List<Port>> getNotUsingIpPort(){
		List<Port> list = networkManagerDao.selectNotUsingIpPort();
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
}
