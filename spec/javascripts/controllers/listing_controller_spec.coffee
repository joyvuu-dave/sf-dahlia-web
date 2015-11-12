do ->
  'use strict'
  describe 'ListingController', ->

    jasmine.getJSONFixtures().fixturesPath = '/public/json'
    scope = undefined
    state = undefined
    fakeListingService = undefined
    fakeSharedService = undefined
    fakeListings = getJSONFixture('/listings.json').listings
    fakeListing = getJSONFixture('/listings/0.json').listing
    fakeListingFavorites = {}

    beforeEach module('dahlia.controllers', ($provide) ->
      fakeListingService =
        listings: fakeListings
        listing: fakeListing
        favorites: fakeListingFavorites
      fakeListingService.toggleFavoriteListing = jasmine.createSpy()
      fakeListingService.isFavorited = jasmine.createSpy()
      $provide.value 'ListingService', fakeListingService
      return
    )

    beforeEach inject(($rootScope, $controller) ->
      scope = $rootScope.$new()
      $controller 'ListingController',
        $scope: scope
        $state: state
        SharedService: fakeSharedService
      return
    )

    describe '$scope.listings', ->
      it 'populates scope with array of listings', ->
        expect(scope.listings).toEqual fakeListings
        return
      return

    describe '$scope.listings', ->
      it 'populates scope with a single listing', ->
        expect(scope.listing).toEqual fakeListing
        return
      return

    describe '$scope.favorites', ->
      it 'populates scope with favorites', ->
        expect(scope.favorites).toEqual fakeListingFavorites
        return
      return

    describe '$scope.toggleFavoriteListing', ->
      it 'expect ListingService.function to be called', ->
        scope.toggleFavoriteListing 1
        expect(fakeListingService.toggleFavoriteListing).toHaveBeenCalled()
        return
      return

    describe '$scope.isFavorited', ->
      it 'expects ListingService.function to be called', ->
        listingId = fakeListing.id
        scope.isFavorited(listingId)
        expect(fakeListingService.isFavorited).toHaveBeenCalled()
        return
    return
  return