package com.simjava.repository;

import com.simjava.domain.security.Student;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class StudentRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private StudentRepository studentRepository;

    @Test
    public void testFindByNis() {
        // Create a test student
        Student student = new Student();
        student.setNis("12345678");
        student.setNamaLengkap("Test Student");
        student.setEmail("test@example.com");
        student.setTelp("081234567890");
        student.setJenisKelamin('L');
        student.setAgama("Islam");
        student.setClassRoomId(1L);
        student.setUserId(1L);
        
        // Save the student
        entityManager.persist(student);
        entityManager.flush();
        
        // Find the student by NIS
        Optional<Student> found = studentRepository.findByNis("12345678");
        
        // Assert that the student was found
        assertThat(found).isPresent();
        assertThat(found.get().getNamaLengkap()).isEqualTo("Test Student");
        assertThat(found.get().getEmail()).isEqualTo("test@example.com");
    }
    
    @Test
    public void testFindAll() {
        // Create test students
        Student student1 = new Student();
        student1.setNis("12345678");
        student1.setNamaLengkap("Test Student 1");
        student1.setEmail("test1@example.com");
        student1.setTelp("081234567890");
        student1.setJenisKelamin('L');
        student1.setAgama("Islam");
        student1.setClassRoomId(1L);
        student1.setUserId(1L);
        
        Student student2 = new Student();
        student2.setNis("87654321");
        student2.setNamaLengkap("Test Student 2");
        student2.setEmail("test2@example.com");
        student2.setTelp("089876543210");
        student2.setJenisKelamin('P');
        student2.setAgama("Kristen");
        student2.setClassRoomId(2L);
        student2.setUserId(2L);
        
        // Save the students
        entityManager.persist(student1);
        entityManager.persist(student2);
        entityManager.flush();
        
        // Find all students
        List<Student> students = studentRepository.findAll();
        
        // Assert that both students were found
        assertThat(students).hasSize(2);
        assertThat(students).extracting(Student::getNis).containsExactlyInAnyOrder("12345678", "87654321");
    }
    
    @Test
    public void testExistsByNis() {
        // Create a test student
        Student student = new Student();
        student.setNis("12345678");
        student.setNamaLengkap("Test Student");
        student.setEmail("test@example.com");
        student.setTelp("081234567890");
        student.setJenisKelamin('L');
        student.setAgama("Islam");
        student.setClassRoomId(1L);
        student.setUserId(1L);
        
        // Save the student
        entityManager.persist(student);
        entityManager.flush();
        
        // Check if student exists by NIS
        boolean exists = studentRepository.existsByNis("12345678");
        boolean notExists = studentRepository.existsByNis("99999999");
        
        // Assert that the student exists
        assertThat(exists).isTrue();
        assertThat(notExists).isFalse();
    }
    
    @Test
    public void testFindByEmail() {
        // Create a test student
        Student student = new Student();
        student.setNis("12345678");
        student.setNamaLengkap("Test Student");
        student.setEmail("test@example.com");
        student.setTelp("081234567890");
        student.setJenisKelamin('L');
        student.setAgama("Islam");
        student.setClassRoomId(1L);
        student.setUserId(1L);
        
        // Save the student
        entityManager.persist(student);
        entityManager.flush();
        
        // Find the student by email
        Optional<Student> found = studentRepository.findByEmail("test@example.com");
        
        // Assert that the student was found
        assertThat(found).isPresent();
        assertThat(found.get().getNis()).isEqualTo("12345678");
        assertThat(found.get().getNamaLengkap()).isEqualTo("Test Student");
    }
} 