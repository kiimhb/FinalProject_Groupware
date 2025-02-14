package com.spring.med.attendance.domain;

public class WorkVO {

		private int work_no;
		private int  fk_member_userid;
		private String work_recorddate;
		private String work_starttime;
		private String  work_endtime;
		private int  work_startstatus;
		private int  work_endstatus;
		 
	 
		public int getWork_no() {
			return work_no;
		}
		public void setWork_no(int work_no) {
			this.work_no = work_no;
		}
		public int getFk_member_userid() {
			return fk_member_userid;
		}
		public void setFk_member_userid(int fk_member_userid) {
			this.fk_member_userid = fk_member_userid;
		}
		public String getWork_recorddate() {
			return work_recorddate;
		}
		public void setWork_recorddate(String work_recorddate) {
			this.work_recorddate = work_recorddate;
		}
		public String getWork_starttime() {
			return work_starttime;
		}
		public void setWork_starttime(String work_starttime) {
			this.work_starttime = work_starttime;
		}
		public String getWork_endtime() {
			return work_endtime;
		}
		public void setWork_endtime(String work_endtime) {
			this.work_endtime = work_endtime;
		}
		public int getWork_startstatus() {
			return work_startstatus;
		}
		public void setWork_startstatus(int work_startstatus) {
			this.work_startstatus = work_startstatus;
		}
		public int getWork_endstatus() {
			return work_endstatus;
		}
		public void setWork_endstatus(int work_endstatus) {
			this.work_endstatus = work_endstatus;
		}
	 
	 
}
