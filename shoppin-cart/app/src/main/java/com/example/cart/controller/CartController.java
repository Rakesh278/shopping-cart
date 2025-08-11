package com.example.cart.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CartController {

    @GetMapping("/cart")
    public String getCart() {
        return "Your cart is empty!";
    }
}
