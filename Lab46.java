import java.util.Scanner;
public class Lab46 {
    public static void main(String[] args) {
    
        Scanner sc = new Scanner(args[0]);
        String str = sc.nextLine();
        int length = args.length;
        for (int i = 0; i < length; i++){
            if( args[i].charAt(0) <= 'A' || args[i].charAt(0) >= 'Z'){
                System.out.println();
                System.out.println("\t\t\t* ERROR *");
                System.out.println();
                return;
            }
        }
        System.out.println("All Characters are Capital");
    }
}