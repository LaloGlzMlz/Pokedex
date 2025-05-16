//
//  PokedexUITests.swift
//  PokedexUITests
//
//  Created by Eduardo Gonzalez Melgoza on 14/05/25.
//

import XCTest

final class PokedexUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Launch app before each test
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testPokedexListLoads() throws {
        XCTAssertTrue(app.navigationBars["Pokédex"].exists)
        XCTAssertTrue(app.cells.firstMatch.exists)
    }
    
    func testTapFirstPokemonShowsDetail() throws {
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["heightLabel"].exists)
    }

    func testBackFromDetailReturnsToList() throws {
        // Start from home screen
        XCTAssertTrue(app.navigationBars["Pokédex"].exists)

        // Tap on first Pokémon
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()

        // Confirm on detail screen
        XCTAssertTrue(app.staticTexts["heightLabel"].exists)

        // Tap back to return
        app.navigationBars.buttons.firstMatch.tap()

        // Confirm navigation back
        XCTAssertTrue(app.navigationBars["Pokédex"].exists)
    }
    
    func testSearchFiltersPokemon() throws {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)

        // Tap search field
        searchField.tap()
        
        // Type in search text and wait for results to filter
        searchField.typeText("ulba")
        
        // Add delay for UI to update and display filtered result
        let filteredCell = app.cells.firstMatch
        
        // Verify the filtered result is correct
        XCTAssertTrue(filteredCell.staticTexts["Bulbasaur"].exists, "The filtered Pokémon cell should contain 'Mewtwo'.")
    }

    func testAbilitiesDisclosureGroupOpens() {
        app.cells.firstMatch.tap()
        
        let abilitiesGroup = app.buttons["Abilities"]
        XCTAssertTrue(abilitiesGroup.exists)
        
        abilitiesGroup.tap()
        
        // Wait for animation to finish
        sleep(1)
        
        let abilityText = app.staticTexts.element(matching: NSPredicate(format: "label CONTAINS[c] %@", "Overgrow"))
        XCTAssertTrue(abilityText.exists)
    }

}
