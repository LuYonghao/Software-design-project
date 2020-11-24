package testExTester;

import java.util.Arrays;

public class Testers {
	public static void main(String[] args) {
		int arr[] = {1,2,3,4,6};
		System.out.println(tri3(arr, 8));
	}
	
	
	static void incre(int i, int [][] arr) {
		i = i - 1;
		arr[i][9] += 1;
		for(int k = 0; k < arr[i].length; k ++) {
			if (arr[i][9-k] == 2) {
				arr[i][9-k - 1] += 1;
				arr[i][9-k] = 0;
			}
		}
	}
	
	
	static int compare(int[] arr1, int[] arr2) {
		int k1 = 0, k2 = 0, r1 = 0, r2 = 0;
		for(int i = arr1.length - 1; i >= 0; i --) {
			r1 += arr1[i] * Math.pow(2, k1);
			k1 ++;
		}
		for(int i = arr2.length - 1; i >= 0; i --) {
			r2 += arr2[i] * Math.pow(2, k2);
			k2 ++;
		}
		if ((r1 - r2) > 0) {
			return 1;
		}else if ((r1 - r2) == 0) {
			return 0;
		}else {
			return -1;
		}
	}

	
	static int tri(int[] arr, int t) {
		Arrays.sort(arr);
		int result = 0;
		for (int i = 0; i < arr.length; i++) {
			int j = i + 1, k = arr.length - 1;
			while (j < k) {
				if (arr[i] + arr[j] + arr[k] > t) {
					k --;
				}else {
					result += (k - j);
					j ++;
				}
			}
		}
		return result;
	}
	
	static int tri2(int[] arr, int t) {
		Arrays.sort(arr);
		int result = 0;
		int counter = 0;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] <= t) {
				counter = i;
			}
		}
		for (int i = 0; i <= counter; i++) {
			int j = i + 1, k = counter;
			while (j < k) {
				if (arr[i] + arr[j] + arr[k] > t) {
					k --;
				}else {
					result += (k - j);
					j ++;
				}
			}
		}
		return result;
	}
	
	static int tri3(int[] arr, int t) {
		Arrays.sort(arr);
		int result = 0;
		int counter = 0;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] <= t) {
				counter = i;
			}
		}
		int i = 0;
		int j = i + 1, k = counter;
		while (i < arr.length) {
			int caseNumber = 0;
			if (j < k) {
				caseNumber = 1;
			}else {
				caseNumber = 2;
			}
			switch (caseNumber) {
			case 1:
				if (arr[i] + arr[j] + arr[k] > t) {
					k --;
				}else {
					result += (k - j);
					j ++;
				}
				break;
			case 2:
				i ++;
				j = i + 1;
				k = counter;
				break;

			default:
				break;
			}
		}
		
		return result;
	}
}
