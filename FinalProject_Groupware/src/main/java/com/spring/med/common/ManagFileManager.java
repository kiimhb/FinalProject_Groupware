package com.spring.med.common;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Calendar;
import org.springframework.stereotype.Component;

// === ManagFileManager 클래스 생성하기 === //
@Component
public class ManagFileManager {

   public String doFileUpload(byte[] bytes, String originalFilename, String path) throws Exception {
      
      String newFileName = null;
      
      if (bytes == null || originalFilename == null || "".equals(originalFilename)) {
           return "default_profile.png"; // 파일이 없을 경우 기본 이미지 반환
       }

       String fileExt = originalFilename.substring(originalFilename.lastIndexOf(".")); 
       if (fileExt == null || "".equals(fileExt) || ".".equals(fileExt)) {
           return "default_profile.png"; // 확장자가 이상하면 기본 이미지 반환
       }
      
      newFileName = String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); 
      newFileName += System.nanoTime();
      newFileName += fileExt;
      
      File dir = new File(path);
   
      if(!dir.exists()) {
         // 만약에 파일을 저장할 경로인 폴더가 실제로 존재하지 않는다면
         
         dir.mkdirs(); // 파일을 저장할 경로인 폴더를 생성한다.
      }
      
      String pathname = path + File.separator + newFileName; 
      
      FileOutputStream fos = new FileOutputStream(pathname);
      
      fos.write(bytes);
      
      fos.close();
      
      return newFileName;
      
   }// end of public String doFileUpload(byte[] bytes, String originalFilename, String path) throws Exception-----------
   
    // === 파일 삭제하기 === //
   public void doFileDelete(String filename, String path) throws Exception {
       if ("default_profile.png".equals(filename)) {
           return; // 기본 이미지는 삭제하지 않음
       }

       String pathname = path + File.separator + filename;
       File file = new File(pathname);

       if (file.exists()) {
           file.delete();
       }
   }// end of public void doFileDelete(String filename, String path) throws Exception------

   
}







