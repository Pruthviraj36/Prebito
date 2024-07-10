import java.util.*;
public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter a String : ");
        String string = sc.nextLine();
        System.out.println(reverseAfterVowels(string));
    }

    public static String reverseAfterVowels(String str) {
        StringBuilder result = new StringBuilder();
        boolean vowelFound = false;

        for (int i = str.length() - 1; i >= 0; i--) {
            char c = str.charAt(i);
            if (isVowel(c)) {
                vowelFound = true;
            }
            if (vowelFound) {
                result.append(c);
            } else {
                result.insert(0, c);
            }
        }

        return result.toString();
    }

    public static boolean isVowel(char c) {
        c = Character.toLowerCase(c);
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
    }
}