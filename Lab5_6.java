class ObjectCounter {
    static int count = 0; // static variable to count the number of objects

    ObjectCounter() {
        count++; // Increment the count each time a new object is created
    }

    public static void main(String[] args) {
        ObjectCounter obj1 = new ObjectCounter();
        ObjectCounter obj2 = new ObjectCounter();
        ObjectCounter obj3 = new ObjectCounter();

        System.out.println("Number of objects created: " + ObjectCounter.count); // Print the count of objects
    }
}