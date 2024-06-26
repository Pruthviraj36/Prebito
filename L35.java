import java.util.*;
 class Student{
    int id_no;
    int no_of_subjects_registered;
    int[] subject_code;
    int[] subject_credit;
    int[] grad_obtained;
    double spi;

    public Student() {
       Scanner sc = new Scanner(System.in);
       System.out.println("Enter the id no :"); 
       id_no = sc.nextInt();
       System.out.println("Enter the no of subjects registered :");
       no_of_subjects_registered = sc.nextInt();

       subject_code = new int[no_of_subjects_registered];
       subject_credit = new int[no_of_subjects_registered];
       grad_obtained = new int[no_of_subjects_registered];

          for(int i=0; i<no_of_subjects_registered;i++) {

              System.out.println("Enter the subject code  "+(i+1)+" :");
              subject_code[i] = sc.nextInt();
              System.out.println("Enter the subject credit  "+(i+1)+"  :");
              subject_credit[i] = sc.nextInt();
              
              System.out.println("Enter the grad obtained "+(i+1)+" :");
              grad_obtained[i] = sc.nextInt();          

          }

    }

    public double calculate_spi() {
        double totalCredits = 0;
        double weightedSum = 0;

        for (int i = 0; i < no_of_subjects_registered; i++) {
            totalCredits += subject_credit[i];
            weightedSum += subject_credit[i] * grad_obtained[i];
        }

        spi = weightedSum / totalCredits;
        return spi;
    }

        public void  printSpi(double spi){


            System.out.println("SPI  is :"  +spi);
        }

 }

public class L_35 {
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the no of students :");
        int n = sc.nextInt();
        Student[] s1 = new Student[n];

        for(int j=0; j<n;j++) {
            
            s1[j] = new Student();
            s1[j].calculate_spi();
            s1[j].printSpi(s1[j].calculate_spi());
        
        }
    
    }

}