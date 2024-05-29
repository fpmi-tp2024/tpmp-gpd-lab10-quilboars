//
//  DataSeeder.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation

class DataSeeder
{
    private let _ctxManager: ContextManager;
    private var _userRepository: UserRepository;
    private var _localityRepository: LocalityRepository;
    private var _routeRepository: RouteRepository;
    private var _rideRepository: RideRepository;
    private var _bookedTicketRepository: BookedTicketRepository;
    
    init(ctxManager: ContextManager)
    {
        _ctxManager = ctxManager;
        _userRepository = UserRepository(contextManager: ctxManager);
        _localityRepository = LocalityRepository(contextManager: ctxManager);
        _routeRepository = RouteRepository(contextManager: ctxManager);
        _rideRepository = RideRepository(contextManager: ctxManager);
        _bookedTicketRepository = BookedTicketRepository(contextManager: ctxManager);
    }
    
    public func SeedLocalities(){
        _localityRepository.AddLocality(name: "Minsk", latitude: 53.893009, longitude: 27.567444);
        _localityRepository.AddLocality(name: "Grodno", latitude: 53.669353, longitude: 23.813131);
        _localityRepository.AddLocality(name: "Brest", latitude: 52.097622, longitude: 23.734051);
        _localityRepository.AddLocality(name: "Mogilev", latitude: 53.900716, longitude: 30.331360);
        _localityRepository.AddLocality(name: "Vitebsk", latitude: 55.184806, longitude: 30.201622);
        _localityRepository.AddLocality(name: "Gomel", latitude: 52.441176, longitude: 30.987846);
    }
    
    public func SeedRoutes()
    {
        let localityMinsk: [Locality]? = _localityRepository.GetLocalityByName(name: "Minsk");
        let localityBrest: [Locality]? = _localityRepository.GetLocalityByName(name: "Brest");
        let localityGomel: [Locality]? = _localityRepository.GetLocalityByName(name: "Gomel");
        let localityVitebsk: [Locality]? = _localityRepository.GetLocalityByName(name: "Vitebsk");
        let localityMogilev: [Locality]? = _localityRepository.GetLocalityByName(name: "Mogilev");
        let localityGrodno: [Locality]? = _localityRepository.GetLocalityByName(name: "Grodno");
        
        
        
        _routeRepository.AddRoute(from: localityMinsk![0], to: localityBrest![0]);
        
        _routeRepository.AddRoute(from: localityMinsk![0], to: localityGrodno![0]);
        
        _routeRepository.AddRoute(from: localityMinsk![0], to: localityMogilev![0]);
        
        _routeRepository.AddRoute(from: localityMinsk![0], to: localityVitebsk![0]);
        
        _routeRepository.AddRoute(from: localityMinsk![0], to: localityGomel![0]);
        
        _routeRepository.AddRoute(from: localityBrest![0], to: localityGrodno![0]);
        
        _routeRepository.AddRoute(from: localityBrest![0], to: localityMogilev![0]);
        
        _routeRepository.AddRoute(from: localityBrest![0], to: localityVitebsk![0]);
        
        _routeRepository.AddRoute(from: localityBrest![0], to: localityGomel![0]);
        
        _routeRepository.AddRoute(from: localityGrodno![0], to: localityMogilev![0]);
        
        _routeRepository.AddRoute(from: localityGrodno![0], to: localityVitebsk![0]);
        
        _routeRepository.AddRoute(from: localityGrodno![0], to: localityGomel![0]);
        
        _routeRepository.AddRoute(from: localityMogilev![0], to: localityVitebsk![0]);
        
        _routeRepository.AddRoute(from: localityMogilev![0], to: localityGomel![0]);
        
        _routeRepository.AddRoute(from: localityVitebsk![0], to: localityGomel![0]);
        
        
        //-------------------------------------------------------
        _routeRepository.AddRoute(from: localityBrest![0], to: localityMinsk![0]);
        
        _routeRepository.AddRoute(from: localityGrodno![0], to: localityMinsk![0]);
        
        _routeRepository.AddRoute(from: localityMogilev![0], to: localityMinsk![0]);
        
        _routeRepository.AddRoute(from: localityVitebsk![0], to: localityMinsk![0]);
        
        _routeRepository.AddRoute(from: localityGomel![0], to: localityMinsk![0]);
        
        _routeRepository.AddRoute(from: localityGrodno![0], to: localityBrest![0]);
        
        _routeRepository.AddRoute(from: localityMogilev![0], to: localityBrest![0]);
        
        _routeRepository.AddRoute(from: localityVitebsk![0], to: localityBrest![0]);
        
        _routeRepository.AddRoute(from: localityGomel![0], to: localityBrest![0]);
        
        _routeRepository.AddRoute(from: localityMogilev![0], to: localityGrodno![0]);
        
        _routeRepository.AddRoute(from: localityVitebsk![0], to: localityGrodno![0]);
        
        _routeRepository.AddRoute(from: localityGomel![0], to: localityGrodno![0]);
        
        _routeRepository.AddRoute(from: localityVitebsk![0], to: localityMogilev![0]);
        
        _routeRepository.AddRoute(from: localityGomel![0], to: localityMogilev![0]);
        
        _routeRepository.AddRoute(from: localityGomel![0], to: localityVitebsk![0]);
    }
    
    public func SeedRides()
    {
        /*let route = _routeRepository.GetRoutesFrom(fromLocalityName: "Minsk")![0];
        
        let formatter = DateFormatter();
        //formatter.timeZone = TimeZone(
        formatter.dateFormat = "dd.MM.yyyy HH:mm";
        let departure = formatter.date(from: "10.06.2024 05:00");
        let arrival = formatter.date(from: "10.06.2024 11:09");
        
        _rideRepository.AddRide(departureTime: departure!, arrivalTime: arrival!, duration: 309, availiableTickets: 25, price: 19.6, route: route)*/
        
        
        //---------------------------------------------------
        
        let routeMinskBrest = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Brest");
        
        SeedTimeTableForRoute(route: routeMinskBrest![0], price: 19.5, duration: 228, availiableTickets: 25);
        
        let routeMinskGrodno = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Grodno");
        
        SeedTimeTableForRoute(route: routeMinskGrodno![0], price: 14.5, duration: 187, availiableTickets: 30);
        
        let routeMinskMogilev = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Mogilev");
        
        SeedTimeTableForRoute(route: routeMinskMogilev![0], price: 13, duration: 139, availiableTickets: 20)
        
        let routeMinskVitebsk = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Vitebsk");
        
        SeedTimeTableForRoute(route: routeMinskVitebsk![0], price: 15, duration: 197, availiableTickets: 24)
        
        let routeMinskGomel = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Gomel");
        
        SeedTimeTableForRoute(route: routeMinskGomel![0], price: 19, duration: 213, availiableTickets: 23)
        
        let routeBrestGrodno = _routeRepository.GetRoute(fromLocalityName: "Brest", toLocalityName: "Grodno");
        
        SeedTimeTableForRoute(route: routeBrestGrodno![0], price: 18, duration: 195, availiableTickets: 22)
        
        let routeBrestMogilev = _routeRepository.GetRoute(fromLocalityName: "Brest", toLocalityName: "Mogilev");
        
        SeedTimeTableForRoute(route: routeBrestMogilev![0], price: 25.5, duration: 338, availiableTickets: 27)
        
        let routeBrestVitebsk = _routeRepository.GetRoute(fromLocalityName: "Brest", toLocalityName: "Vitebsk");
        
        SeedTimeTableForRoute(route: routeBrestVitebsk![0], price: 40, duration: 407, availiableTickets: 29)
        
        let routeBrestGomel = _routeRepository.GetRoute(fromLocalityName: "Brest", toLocalityName: "Gomel");
        
        SeedTimeTableForRoute(route: routeBrestGomel![0], price: 41, duration: 414, availiableTickets: 20)
        
        let routeGrodnoMogilev = _routeRepository.GetRoute(fromLocalityName: "Grodno", toLocalityName: "Mogilev");
        
        SeedTimeTableForRoute(route: routeGrodnoMogilev![0], price: 26, duration: 313, availiableTickets: 25)
        
        let routeGrodnoVitebsk = _routeRepository.GetRoute(fromLocalityName: "Grodno", toLocalityName: "Vitebsk");
        
        SeedTimeTableForRoute(route: routeGrodnoVitebsk![0], price: 30.5, duration: 373, availiableTickets: 23)
        
        let routeGrodnoGomel = _routeRepository.GetRoute(fromLocalityName: "Grodno", toLocalityName: "Gomel");
        
        SeedTimeTableForRoute(route: routeGrodnoGomel![0], price: 27.5, duration: 309, availiableTickets: 25)
        
        let routeMogilevVitebsk = _routeRepository.GetRoute(fromLocalityName: "Mogilev", toLocalityName: "Vitebsk");
        
        SeedTimeTableForRoute(route: routeMogilevVitebsk![0], price: 29.5, duration: 388, availiableTickets: 31)
        
        let routeMogilevGomel = _routeRepository.GetRoute(fromLocalityName: "Mogilev", toLocalityName: "Gomel");
        
        SeedTimeTableForRoute(route: routeMogilevGomel![0], price: 19, duration: 156, availiableTickets: 23)
        
        let routeVitebskGomel = _routeRepository.GetRoute(fromLocalityName: "Vitebsk", toLocalityName: "Gomel");
        
        SeedTimeTableForRoute(route: routeVitebskGomel![0], price: 23, duration: 264, availiableTickets: 34)
        
        // ------------------------------------------------
        
        
        let routeBrestMinsk = _routeRepository.GetRoute(fromLocalityName: "Brest", toLocalityName: "Minsk");
        
        SeedTimeTableForRoute(route: routeBrestMinsk![0], price: 19.5, duration: 228, availiableTickets: 25);
        
        let routeGrodnoMinsk = _routeRepository.GetRoute(fromLocalityName: "Grodno", toLocalityName: "Minsk");
        
        SeedTimeTableForRoute(route: routeGrodnoMinsk![0], price: 14.5, duration: 187, availiableTickets: 30);
        
        let routeMogilevMinsk = _routeRepository.GetRoute(fromLocalityName: "Mogilev", toLocalityName: "Minsk");
        
        SeedTimeTableForRoute(route: routeMogilevMinsk![0], price: 13, duration: 139, availiableTickets: 20)
        
        let routeVitebskMinsk = _routeRepository.GetRoute(fromLocalityName: "Vitebsk", toLocalityName: "Minsk");
        
        SeedTimeTableForRoute(route: routeVitebskMinsk![0], price: 15, duration: 197, availiableTickets: 24)
        
        let routeGomelMinsk = _routeRepository.GetRoute(fromLocalityName: "Gomel", toLocalityName: "Minsk");
        
        SeedTimeTableForRoute(route: routeGomelMinsk![0], price: 19, duration: 213, availiableTickets: 23)
        
        let routeGrodnoBrest = _routeRepository.GetRoute(fromLocalityName: "Grodno", toLocalityName: "Brest");
        
        SeedTimeTableForRoute(route: routeGrodnoBrest![0], price: 18, duration: 195, availiableTickets: 22)
        
        let routeMogilevBrest = _routeRepository.GetRoute(fromLocalityName: "Mogilev", toLocalityName: "Brest");
        
        SeedTimeTableForRoute(route: routeMogilevBrest![0], price: 25.5, duration: 338, availiableTickets: 27)
        
        let routeVitebskBrest = _routeRepository.GetRoute(fromLocalityName: "Vitebsk", toLocalityName: "Brest");
        
        SeedTimeTableForRoute(route: routeVitebskBrest![0], price: 40, duration: 407, availiableTickets: 29)
        
        let routeGomelBrest = _routeRepository.GetRoute(fromLocalityName: "Gomel", toLocalityName: "Brest");
        
        SeedTimeTableForRoute(route: routeGomelBrest![0], price: 41, duration: 414, availiableTickets: 20)
        
        let routeMogilevGrodno = _routeRepository.GetRoute(fromLocalityName: "Mogilev", toLocalityName: "Grodno");
        
        SeedTimeTableForRoute(route: routeMogilevGrodno![0], price: 26, duration: 313, availiableTickets: 25)
        
        let routeVitebskGrodno = _routeRepository.GetRoute(fromLocalityName: "Vitebsk", toLocalityName: "Grodno");
        
        SeedTimeTableForRoute(route: routeVitebskGrodno![0], price: 30.5, duration: 373, availiableTickets: 23)
        
        let routeGomelGrodno = _routeRepository.GetRoute(fromLocalityName: "Gomel", toLocalityName: "Grodno");
        
        SeedTimeTableForRoute(route: routeGomelGrodno![0], price: 27.5, duration: 309, availiableTickets: 25)
        
        let routeVitebskMogilew = _routeRepository.GetRoute(fromLocalityName: "Vitebsk", toLocalityName: "Mogilev");
        
        SeedTimeTableForRoute(route: routeVitebskMogilew![0], price: 29.5, duration: 388, availiableTickets: 31)
        
        let routeGomelMogilev = _routeRepository.GetRoute(fromLocalityName: "Gomel", toLocalityName: "Mogilev");
        
        SeedTimeTableForRoute(route: routeGomelMogilev![0], price: 19, duration: 156, availiableTickets: 23)
        
        let routeGomelVitebsk = _routeRepository.GetRoute(fromLocalityName: "Gomel", toLocalityName: "Vitebsk");
        
        SeedTimeTableForRoute(route: routeGomelVitebsk![0], price: 23, duration: 264, availiableTickets: 34)
    }
    
    private func SeedTimeTableForRoute(route: Route, price: Float, duration: Int32, availiableTickets: Int32)
    {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        let calendar = Calendar.current;
        
        for month in 6...7
        {
            for day in 1...days[month - 1]
            {
                let formatter = DateFormatter();
                formatter.dateFormat = "dd.MM.yyyy HH:mm";
                let stringDateFormat = "%d.%d.2024 00:01";
                let stringDate = String(format: stringDateFormat, day, month);
                var departure: Date! = formatter.date(from: stringDate);
                while(true)
                {
                    let delta = Int.random(in: 150...270);
                    departure = calendar.date(byAdding: .minute, value: delta, to: departure);
                    
                    let dateFormatter = DateFormatter();
                    dateFormatter.dateFormat = "dd";
                    
                    let dayDep = Int(dateFormatter.string(from: departure))!;
                    
                    if(dayDep != day){
                        break;
                    }
                    
                    let arrival = calendar.date(byAdding: .minute, value: Int(duration), to: departure);
                    
                    let priceDelta = Float.random(in: -2...2)
                    
                    _rideRepository.AddRide(departureTime: departure, arrivalTime: arrival!, duration: duration, availiableTickets: availiableTickets, price: price + priceDelta, route: route);
                }
            }
        }
    }
    
    
    
    public func SeedBookedTickets()
    {
        let user = _userRepository.GetUsersByLogin(login: "kris@gmail.com")![0];
        
        let rideArray = _routeRepository.GetRoute(fromLocalityName: "Minsk", toLocalityName: "Brest")![0].rides!.allObjects as! [Ride];
        
        _bookedTicketRepository.BookTicket(user: user, ride: rideArray[0]);
    }
}
