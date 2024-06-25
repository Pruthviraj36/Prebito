import java.util.*;

class L32 {
   
    static boolean areAnagram(char[] str1, char[] str2){
        int n1 = str1.length;
        int n2 = str2.length;
 
        if (n1 != n2)
            return false;
 
        Arrays.sort(str1);
        Arrays.sort(str2);
 
        for (int i = 0; i < n1; i++)
            if (str1[i] != str2[i])
                return false;
 
        return true;
    }
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Random random=new Random();
        System.out.println("Enter a String Seperated by comma :");
        String str = sc.nextLine();
        String[] strArr = new String[str.length()];
        strArr = str.split(",");
        
        for (int i = 0; i<strArr.length; i++){
            System.out.println(strArr[i]);
        }
        int randomNum = random.nextInt(strArr.length-1);
        
        String original="";
        String anagram="";
        
        
        for (int i = 0; i<strArr.length; i++) {
            if (i == randomNum) {
                System.out.println("\nThe Word is \""+strArr[i]+"\" enter its Anagram");
                anagram = sc.nextLine();
                original = strArr[i];
            }
        }
        
        char[] ori = new char[original.length()];
        char[] ana = new char[anagram.length()];
 
        for (int i = 0; i < original.length(); i++) {
            ori[i] = original.charAt(i);
        }
        for (int i = 0; i < anagram.length(); i++) {
            ana[i] = anagram.charAt(i);
        }
        
        if (areAnagram(ori, ana))
            System.out.println("The two strings are"
            + " anagram of each other");
        else
            System.out.println("The two strings are not"
                               + " anagram of each other");
        
        sc.close();     
    }
}