/*
* NeedlemanWunsch.java
*
* Created on 9 december 2006, 18:24
*/
package bioinfo;
import java.util.ArrayList;
/**
* @author DS
*/
public class NeedlemanWunsch {
public static final int A=0, G=1, C=2, T=3;
public static final int d = -5;
// A G C T
public static int[] simularity = {10, -1, -3, -4, //A
								  -1,  7, -5, -3, //G
								  -3, -5,  9,  0, //C
								  -4, -3,  0,  8};//T
								  
public static void main(String[] arg)
{
	// int[] ar = NeedlemanWunsch.convertStringToArr("TCGAAGCT");
	// System.out.println(ar);
	System.out.println(NeedlemanWunsch.simular(0,0));
	System.out.println(NeedlemanWunsch.simular(1,0));
	int[][] ar = NeedlemanWunsch.calculateMatrix(convertStringToArr("AGACTAGTTAC"), convertStringToArr("AGACTAGTTAC"));
	for (int y = 0; y < ar.length; y++)
		{
		System.out.println("");
		for (int x = 0; x < ar[y].length; x++)
			System.out.print(ar[y][x] +"\t ");
		}
	NeedlemanWunsch.getAlignments(ar, convertStringToArr("AGACTAGTTAC"), convertStringToArr("AGACTAGTTAC"), "AGACTAGTTAC","AGACTAGTTAC");
}
public static void getAlignments(int[][] ar, int[] A, int[] B, String sA, String sB)
{
	String alA = "";
	String alB = "";
	int i = sA.length();
	int j = sB.length();
	while (i > 0 && j > 0)
	{
		int score = ar[i][j];
		int scorediag = ar[i-1][j-1];
		int scoreup = ar[i][j-1];
		int scoreleft = ar[i-1][j];
		if (score == scorediag + simular(A[i-1], B[j-1]))
		{
			alA = sA.charAt(i-1) + alA;
			alB = sB.charAt(j-1) + alB;
			i--;j--;
		}
		else if (score == scoreleft + d)
		{
			alA = sA.charAt(i-1) + alA;
			alB = "-" + alB;
			i--;
		}
		else if(score == scoreup + d)
		{
			alA = "-" + alA;
			alB = sB.charAt(j-1) + alB;
			j--;
		}
	}
	while(i > 0)
	{
		alA = sA.charAt(i - 1) + alA;
		alB = "-" + alB;
		i--;
	}
	while(j > 0)
	{
		alA = "-" + alA;
		alB = sB.charAt(j - 1) + alB;
		j--;
	}
	System.out.println(alA+"\n");
	System.out.println(alB+"\n");
}

public static int[][] calculateMatrix(int[] source, int[] dest)
{
	int[][] res = new int[source.length+1][dest.length+1];
	for (int y = 0; y < source.length; y++)
		res[y][0] = d * y;
	for (int x = 0; x < dest.length; x++)
		res[0][x] = d * x;
	for (int y = 1; y < source.length + 1; y++)
		for (int x = 1; x < dest.length +1; x++)
		{
			int k = res[y-1][x-1] + simular(source[y-1] , dest[x-1]);
			int l = res[y-1][x] + d;
			int m = res[y][x-1] + d;
			k = Math.max(k,l);
			res[y][x] = Math.max(k,m);
		}
	return res;
}

public static int[] convertStringToArr(String str)
{
	ArrayList l = new ArrayList();
	for (int i = 0; i < str.length(); i++)
	{
		int n = -1;
		if(str.charAt(i) == 'A')
		n= 0;
		if(str.charAt(i) == 'G')
		n= 1;
		if(str.charAt(i) == 'C')
		n= 2;
		if(str.charAt(i) == 'T')
		n= 3;
		l.add(new Integer(n));
	}
	int[] arr = new int[l.size()];
	for (int i = 0; i < l.size();i++)
		arr[i] = ((Integer)l.get(i)).intValue();
	return arr;
}

public static int simular(int first, int second)
{
	return simularity[first * 4 + second];
}
}
