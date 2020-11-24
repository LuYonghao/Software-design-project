package testExTester;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;

public class Tester {
	

	public static void main(String[] args) throws FileNotFoundException {
		
//		for (int j = 0; j < 15; j++) {
//			
//		
//			PrintStream psOld = System.out; 
//			System.setOut(new PrintStream(new File("C:\\Users\\ClarenceLu\\Desktop\\boundary1\\unlimited_boundary_test"+j+".txt")));
//	 
//			int max=85,min=1;
//			for (int i = 0; i < 1500; i++) {
//				int ran = (int) (Math.random()*(max-min)+min); 
//				if (ran < 5) {
//					int t1 = (int) (Math.random()*(40-1)+1);
//					int t2 = (int) (Math.random()*(60-30)+30);
//					int t3 = (int) (Math.random()*(80-40)+40);
//					int t4 = (int) (Math.random()*(90-60)+60);
//					int t5 = (int) (Math.random()*(100-70)+70);
//					System.out.println("test(" + t1 + "," + t2 + "," + t3 + "," + t4 + "," + t5 + ")");
//				}else if (ran < 15) {
//					System.out.println("play");
//				}else if (ran < 20) {
//					System.out.println("abort");
//				}else if (ran < 25) {
//					System.out.println("move(E)");
//				}else if (ran < 30) {
//					System.out.println("move(W)");
//				}else if (ran < 35) {
//					System.out.println("move(S)");
//				}else if (ran < 40) {
//					System.out.println("move(N)");
//				}else if (ran < 45) {
//					System.out.println("move(SE)");
//				}else if (ran < 50) {
//					System.out.println("move(SW)");
//				}else if (ran < 55) {
//					System.out.println("move(NE)");
//				}else if (ran < 60) {
//					System.out.println("move(NW)");
//				}else if (ran < 65) {
//					System.out.println("status");
//				}else if (ran < 70) {
//					System.out.println("land");
//				}else if (ran < 75) {
//					System.out.println("liftoff");
//				}else if (ran < 80) {
//					System.out.println("wormhole");
//				}else {
//					System.out.println("pass");
//				}
//			}
//			System.setOut(psOld); 
//		}
		for (int j = 0; j < 10; j++) {
			
			
			PrintStream psOld = System.out; 
			System.setOut(new PrintStream(new File("C:\\Users\\ClarenceLu\\Desktop\\boundary\\wodemahaiceya"+j+".txt")));
	 
			int max=100,min=1;
			int sizemax = 8, sizemin = 5;
			int size  = (int) (Math.random()*(sizemax-sizemin)+sizemin);
			int kingx = 1, kingy = 1;
			int knightx = size, knighty = size;
			
			for (int i = 0; i < 70; i++) {
				int ran = (int) (Math.random()*(max-min)+min); 
				if(ran < 5) {
					System.out.println("play(" + size + ")");
				}else if (ran < 30) {
					int ran1 = 8, ran2 = 1;
					int dir =  (int) (Math.random()*(ran1-ran2)+ran2);
					switch (dir) {
					case 1:
						if(kingx - 1 > 0) {
							kingx --;
							break;
						}
					case 2:
						if(kingx + 1 <= size) {
							kingx ++;
							break;
						}
					case 3:
						if(kingy - 1 > 0) {
							kingy --;
							break;
						}
					case 4:
						if(kingy + 1 <= size) {
							kingy ++;
							break;
						}
					case 5:
						if(kingx - 1 > 0 && kingy - 1 > 0) {
							kingx --;
							kingy --;
							break;
						}
					case 6:
						if(kingx + 1 <= size && kingy + 1 <= size) {
							kingx ++;
							kingy ++;
							break;
						}
					case 7:
						if( kingy + 1 <= size && kingx - 1 > 0) {
							kingy ++;
							kingx --;
							break;
						}
					case 8:
						if( kingx + 1 <= size && kingy - 1 > 0) {
							kingy --;
							kingx ++;
							break;
						}
					default :
					}
					System.out.println("move_king([" +kingx+","+kingy+ "])");
				}else if (ran < 60) {
					int ran1 = 8, ran2 = 1;
					int dir =  (int) (Math.random()*(ran1-ran2)+ran2);
					switch (dir) {
					case 1:
						if(knightx + 1 <= size && knighty + 2 <= size) {
							knightx ++;
							knighty += 2;
							break;
						}
					case 2:
						if(knightx + 1 <= size && knighty - 2 > 0) {
							knightx ++;
							knighty -=2;
							break;
						}
					case 3:
						if(knightx - 1 >0 && knighty + 2 <= size) {
							knightx --;
							knighty += 2;
							break;
						}
					case 4:
						if(knightx - 1 > 0 && knighty - 2 > 0) {
							knightx --;
							knighty -=2;
							break;
						}
					case 5:
						if(knighty - 1 > 0 && knightx + 2 <= size) {
							knightx += 2;
							knighty --;
							break;
						}
					case 6:
						if(knightx + 2 <= size && knighty + 1 <= size) {
							knightx += 2;
							knighty ++;
							break;
						}
					case 7:
						if(knightx - 2 > 0 && knighty - 1 > 0) {
							knightx -= 2;
							knighty --;
							break;
						}
					case 8:
						if(knightx - 2 > 0 && knighty + 1 <= size) {
							knightx -= 2;
							knighty ++;
							break;
						}
					default :
						}
					System.out.println("move_knight([" +knightx+","+knighty+ "])");
				}else if (ran < 80) {
					System.out.println("undo");
				}else if (ran < 100) {
					System.out.println("redo");
				}
			}
			System.setOut(psOld); 
		}
	}

}
