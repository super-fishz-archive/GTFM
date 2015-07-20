package team.gtfm.server.bean;

public class Room {
	private int seq;
	private String roomName;
	private int buildingSeq;
	private String memo;
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public int getBuildingSeq() {
		return buildingSeq;
	}
	public void setBuildingSeq(int buildingSeq) {
		this.buildingSeq = buildingSeq;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	
}
