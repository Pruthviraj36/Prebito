
import java.util.*;

public class 31 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the row  of the matrix FIRST matrix :");
        int n = sc.nextInt();
        System.out.println("Enter the column  of the matrix FIRST matrix :");
        int m = sc.nextInt();
        int arr1[][] = new int[n][m];

        System.out.println("Enter the row  of the matrix SECOND matrix :");
        int x = sc.nextInt();
        System.out.println("Enter the column  of the matrix SECOND matrix :");
        int y = sc.nextInt();
        int arr2[][] = new int[x][y];

        int arr3[][] = new int[n][y];

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                System.out.println("Enter the ["+i+","+j+"] element of the First array");
                arr1[i][j] = sc.nextInt();
            }
            
        }
        for (int i = 0; i < x; i++) {
            for (int j = 0; j < y; j++) {
                System.out.println("Enter the ["+i+","+j+"] element of the Second array");
                arr2[i][j] = sc.nextInt();
            }
            
        }

        if(m == x){
            for(int i = 0; i < n ; i++ ){
                for(int j = 0; j < y; j++) {
                    for(int k = 0 ;k < x ; k++) {
                        arr3[i][j] += arr1[i][j] * arr2[i][j] ;
                    }
                }
            }
            

        }
        else{
            System.out.println("Matrix multiplication is not possible");
        }

        for(int i = 0; i < n ; i++){
            for(int j = 0; j < y; j++) {
                System.out.print(arr3[i][j] + " ");
            }
            System.out.println();
        }
    }   
}
