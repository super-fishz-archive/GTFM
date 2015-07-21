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

import team.gtfm.server.bean.Building;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.NetworkManagerDao;

@RestController
public class BuildingController {
	private final String contentType = "application/json; charset=utf-8";
	
	//그냥 테스트 용임... 삭제해도 무방
	@Autowired
	private NetworkManagerDao networkManagerDao;
	
	@RequestMapping(value="/data/building", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertBuilding(@RequestBody Building building){
		
		int c = networkManagerDao.insertBuilding(building);
		UpdateResult result = new UpdateResult();
		result.setResult((c > 0)? true : false);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/building",
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<List<Building>> getBuildings(){
		
		List<Building> b = networkManagerDao.selectBuildingAll();
		return new ResponseEntity<>(b, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/building/{seq}",
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Building> getBuildings(@PathVariable String seq){
		
		Building b = networkManagerDao.selectBuilding(Integer.parseInt(seq));
		return new ResponseEntity<>(b, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/building/{seq}",
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteBuilding(@PathVariable String seq){
		
		int c = networkManagerDao.deleteBuilding(Integer.parseInt(seq));
		UpdateResult result = new UpdateResult();
		result.setResult((c > 0)? true : false);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="data/building",
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> updateBuilding(@RequestBody Building building){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
