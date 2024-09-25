import java.util.HashSet;
import java.util.Random;

public class LinearHash {

    private static final int TABLE_SIZE = 20;
    private static final int NUMBER_COUNT = 15;
    private static Integer hashTable[] = new Integer[TABLE_SIZE];

    private static int hashFunction(int x) {
        return (x % 18) + 2;
    }

    private static void insertIntoHashTable(int value) {
        int index = hashFunction(value);
        int ogIndex = index;

        while (hashTable[index] != null) {
            index = (++index) % TABLE_SIZE;
            
            if (index == ogIndex) {
                System.out.println("HashTable is FUll cannot INSERT " + value);
                return;
            }
        }

        hashTable[index] = value;
    }

    public static void main(String[] args) {
        HashSet<Integer> uniqueNumbers = new HashSet<>();
        Random randomNumbers = new Random();

        while (uniqueNumbers.size() < NUMBER_COUNT) {
            int number = 100000 + randomNumbers.nextInt(900000);
            uniqueNumbers.add(number);
        }

        int j = 0;
        System.out.println("\nbefore Storing\n");
        for (int number : uniqueNumbers) {
            System.out.println("Index " + j + "= " + number);
            j++;
            insertIntoHashTable(number);
        }

        System.out.println("\nFinal Hash Table Values:");
        for (int i = 0; i < TABLE_SIZE; i++) {
            System.out.println("Index " + i + ": " + hashTable[i]);
        }
    }
}
