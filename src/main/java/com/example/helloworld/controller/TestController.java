package com.example.helloworld.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@EnableWebMvc
public class TestController {
	@GetMapping(path = "/ping")
	@Operation(description = "Get Hello World")
	@ApiResponses(value = { @ApiResponse(responseCode = "200", description = "OK") })
	public Map<String, String> ping() {
		Map<String, String> pong = new HashMap<>();
		pong.put("pong", "Hello, World!");
		return pong;
	}
}
