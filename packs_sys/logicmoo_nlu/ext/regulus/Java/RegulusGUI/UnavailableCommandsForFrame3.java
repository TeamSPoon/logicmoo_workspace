package RegulusGUI;
import se.sics.prologbeans.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class UnavailableCommandsForFrame3  extends JFrame{
	private RegulusGUI regulusWindow = null;
	private Frame3 frame3 = null;
	private int i = 0;
	
//	get pointer to Regulus window
	public RegulusGUI getRegulusGUI() {
		  return regulusWindow;
	}

//	 set the pointer to the Regulus window
	public void setRegulusGUI(RegulusGUI window) {
		  regulusWindow = window;
	}
//	  get the pointer to frame3 window
	  public Frame3 getFrame3() {
		  return frame3;
	  }
	  
//	 set the pointer to the Frame2 window
	  public void setFrame3(Frame3 window) {
		  frame3 = window;
	  }
	public UnavailableCommandsForFrame3()
	{
		
	}
	public UnavailableCommandsForFrame3(Frame3 frame, RegulusGUI regulusgui){
		frame3 = frame;
		setRegulusGUI(regulusgui);
	}
	
	public void check_unavailable_menus() 
	{
		
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("EBL_LOAD"))
			 frame3.L_EblloadMenuItem.setEnabled(false);
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("LOAD"))
			 frame3.L_loadMenuItem.setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("LOAD_TRANSLATE"))
			 frame3.L_loadMenu.setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("LOAD_RECOGNITION"))
			 frame3.loadRecognitionMenuItem.setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("CLOSE_DOWN_RECOGNITION"))
			 frame3.close_down_recognition_MenuItem.setEnabled(false);
		 //System.out.println("regulusWindow.unavailableCommands[i] "+regulusWindow.unavailableCommands[i]);
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("LOAD_SURFACE_PATTERNS"))
			 frame3.Surface_Patterns_loadMenuItem.setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("NUANCE_COMPILE"))
			 frame3.Compile_Nuance_to_recognicer_MenuItem .setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("NUANCE_COMPILE_WITH_PCFG"))
			 frame3.Compile_Nuance_to_recognicer_pcfg_MenuItem .setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("COMPILE_ELLIPSIS_PATTERNS"))
			 frame3.Compile_Ellipsis_Patterns_loadMenuItem .setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("NUANCE"))
			 frame3.Nuance_loadMenuItem .setEnabled(false);
		
		 }
	  for ( i = 1 ;i < regulusWindow.num_UnAvailable ; i++ )
		 {
		  
		 if (regulusWindow.unavailableCommands[i].equals("GEMINI"))
			 frame3.Gemini_loadMenuItem .setEnabled(false);
		
		 }
	}
}
