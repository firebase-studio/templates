package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
//Security Imports
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;


@SpringBootApplication
@Configuration
public class DemoApplication {

  @Value("${NAME:World}")
  String name;

  @RestController
  class HelloworldController {
    @GetMapping("/")
    String hello() {
      return "Hello " + name + "!";
    }
  }
  //default username and password can be configured from here Username default is user and password temp
  @Bean
  public InMemoryUserDetailsManager userDetailsManger(){
      UserDetails john=org.springframework.security.core.userdetails.User.builder().username("user").password("{noop}temp").roles("Employee").build();
      return new InMemoryUserDetailsManager(john);
  } 

  public static void main(String[] args) {
    SpringApplication.run(DemoApplication.class, args);
  }

}