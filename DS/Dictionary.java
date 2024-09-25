import java.util.LinkedList;

/**
 * HashTable
 */
class HashTable<K, V> {
    private static class HashNode<K, V> {
        K key; 
        V value;

        HashNode(K Key, V Value) {
            this.key = key;
            this.value = value;
        }
    }

    private LinkedList<HashNode<K, V>>[] buckets;
    private int numBuckets;
    private int size;

    public HashTable(int capacity) {
        this.numBuckets = capacity;
        this.buckets = new LinkedList[capacity];
        for (int i = 0; i < capacity; i++) {
            buckets[i] = new LinkedList<>();
        }
        this.size = 0;
    }

    private int getBucketIndex(K key) {
        return Math.abs(key.hashCode()) % numBuckets;
    }

    public void put(K key, V Value) {
        int bucketIndex = 
    }
}

public class Dictionary {
    
}
