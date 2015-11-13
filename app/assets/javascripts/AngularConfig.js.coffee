@dahlia = angular.module 'dahlia', [
  'dahlia.controllers',
  'dahlia.services',
  # filters
  'customFilters',
  # directives
  'customDirectives',
  # dependencies
  'ui.router',
  'angular-clipboard',
  'templates',
  'mm.foundation',
]

# Service and Controller modules
angular.module('dahlia.services', ['ngCookies'])
angular.module('dahlia.controllers',[])

# This routing directive tells Angular about the default route for our  The term "otherwise" here
# might seem somewhat awkward, but it will make more sense as we add more routes to our application
@dahlia.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state('dahlia', {
      url: ''
      abstract: true
      views:
        'nav@':
          templateUrl: 'shared/templates/nav.html'
          controller: 'NavController'
    })
    .state('dahlia.listings', {
      url: '/listings'
      views:
        'container@':
          templateUrl: 'listings/templates/listings.html'
          controller: 'ListingController'
      resolve:
        listings: ['$stateParams', 'ListingService', ($stateParams, ListingService) ->
          ListingService.getFavorites()
          ListingService.getListings()
        ]
    })
    .state('dahlia.listing', {
      url: '/listings/:id',
      views:
        'container@':
          templateUrl: 'listings/templates/listing.html'
          controller: 'ListingController'
      resolve:
        listing: ['$stateParams', 'ListingService', ($stateParams, ListingService) ->
          ListingService.getFavorites()
          ListingService.getListing($stateParams.id)
        ]
    })
    .state('dahlia.favorites', {
      url: '/favorites'
      views:
        'container@':
          templateUrl: 'listings/templates/favorites.html'
          controller: 'ListingController'
      resolve:
        listing: ['$stateParams', 'ListingService', ($stateParams, ListingService) ->
          ListingService.getFavorites()
          ListingService.getFavoriteListings()
        ]
    })
    .state('dahlia.welcome', {
      url: '/'
      views:
        'container@':
          templateUrl: 'pages/templates/welcome.html'
    })
    .state('dahlia.share', {
      url: '/share/:id'
      views:
        'container@':
          templateUrl: 'pages/templates/share.html'
          controller: 'ShareController'
    })
  $urlRouterProvider.otherwise('/') # default to welcome screen
]

@dahlia.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common["X-Requested-With"]
  $httpProvider.defaults.headers.common["Accept"] = "application/json"
  $httpProvider.defaults.headers.common["Content-Type"] = "application/json"

  $httpProvider.interceptors.push ["$location", "$rootScope", "$q", ($location, $rootScope, $q) ->
    success = (response) ->
      response
    error = (response) ->
      if response.status is 401 or 400
        $rootScope.$broadcast "event:unauthorized"
        $location.path ""
        return response
      $q.reject response
    return (promise) ->
      promise.then success, error
  ]
]
