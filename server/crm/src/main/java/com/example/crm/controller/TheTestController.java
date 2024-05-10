package com.example.crm.controller;


import com.example.crm.Mapper.TestClassMapper;
import com.example.crm.interfacePackage.UserLoginToken;
import com.example.crm.pojo.TestClass;
import com.example.crm.util.jwtTool;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TheTestController {


    @Autowired
    TestClassMapper testClass;


    public void toTest(){
        List<TestClass> all = testClass.all();
        all.forEach(e-> System.out.println(e));
    }
    @Autowired
    kk k;

    @UserLoginToken
    @GetMapping("/test")
    public String test(){

        String token=jwtTool.getToken("tom","123456");

        System.out.println("jwt is:"+token);

        boolean result = jwtTool.verify(token);

//        if(result){
//
//            System.out.println("验证成功");
//
//            return "check success";
//
//        }else {
//
//        }
        k.setName("poegjrg");
        return new Gson().toJson(k);

    }
}
