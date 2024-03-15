class Book {
    private String author_name;
    public Book(String author_name) {
        this.author_name = author_name;
    }
    public void printDetails() {
        System.out.println(author_name);
    }
}
class BookPublication extends Book {
    private String title;
    public BookPublication(String author_name, String title) {
        super(author_name);
        this.title = title;
    }
    public void printDetails() {
        super.printDetails();
        System.out.println(title);
    }
}
class PaperPublication extends Book {
    private String title;
    public PaperPublication(String  author_name, String title) {
        super(author_name);
        this.title = title;
    }
    public void printDetails() {
        super.printDetails();
        System.out.println(title);
    }
}
public class Lab6_2 {
    public static void main(String[] args) {
        String author_name = args[0];
        String title = args[1];
        PaperPublication b = new PaperPublication(author_name, title);
        b.printDetails();
    }
}
