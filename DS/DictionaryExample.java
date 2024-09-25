import java.util.LinkedList;

class HashTable<K, V> {
    private static class HashNode<K, V> {
        K key;
        V value;

        HashNode(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }

    private LinkedList<HashNode<K, V>>[] buckets;
    private int numBuckets;
    private int size;

    @SuppressWarnings("unchecked")
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

    public void put(K key, V value) {
        int bucketIndex = getBucketIndex(key);
        LinkedList<HashNode<K, V>> bucket = buckets[bucketIndex];

        for (HashNode<K, V> node : bucket) {
            if (node.key.equals(key)) {
                node.value = value; // Update existing key
                return;
            }
        }

        bucket.add(new HashNode<>(key, value)); // Add new key-value pair
        size++;
    }

    public V get(K key) {
        int bucketIndex = getBucketIndex(key);
        LinkedList<HashNode<K, V>> bucket = buckets[bucketIndex];

        for (HashNode<K, V> node : bucket) {
            if (node.key.equals(key)) {
                return node.value; // Return the value if key is found
            }
        }

        return null; // Key not found
    }

    public void remove(K key) {
        int bucketIndex = getBucketIndex(key);
        LinkedList<HashNode<K, V>> bucket = buckets[bucketIndex];

        for (HashNode<K, V> node : bucket) {
            if (node.key.equals(key)) {
                bucket.remove(node); // Remove the key-value pair
                size--;
                return;
            }
        }
    }

    public int size() {
        return size;
    }

    public boolean containsKey(K key) {
        return get(key) != null;
    }

    public boolean isEmpty() {
        return size == 0;
    }
}

public class DictionaryExample {
    public static void main(String[] args) {
        HashTable<String, Integer> dictionary = new HashTable<>(10);

        dictionary.put("one", 1);
        dictionary.put("two", 2);
        dictionary.put("three", 3);

        System.out.println("Value for 'two': " + dictionary.get("two")); // Output: 2
        System.out.println("Size: " + dictionary.size()); // Output: 3

        dictionary.remove("two");
        System.out.println("Value for 'two' after removal: " + dictionary.get("two")); // Output: null
        System.out.println("Size after removal: " + dictionary.size()); // Output: 2
    }
}
