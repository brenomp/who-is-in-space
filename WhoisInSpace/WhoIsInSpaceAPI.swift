//
//  WhoIsInSpaceAPI.swift
//  WhoisInSpace
//
//  Created by David on 12/31/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WhoIsInSpaceAPI: NSObject, CLLocationManagerDelegate
{
    
    class var sharedInstance:WhoIsInSpaceAPI
    {
        struct Singleton
        {
            static let instance = WhoIsInSpaceAPI()
        }
        
        return Singleton.instance
    }
    
    var astroDictionary: NSDictionary?
    var astroList = [Astronaut]()
    
    let locationManager = CLLocationManager()
    let kLocationDidUpdateNotification = "locationDidUpdateNotification"
    
    var myLatitude: CLLocationDegrees?
    var myLongitude: CLLocationDegrees?
    
    var currentNewsItems = [NewsItem]()
    
    override init()
    {
        super.init()
        self.setup()
    }
    
    func setup()
    {
        // Does the initial setup for the app
        println("In The App Setup")
        
        // Creates the list of astronauts in space
        self.getAstronautList()
        
        // Creates the news feed array
        self.currentNewsItems = NetworkHelper.getNewsFromRssFeed("http://blogs.nasa.gov/spacestation/feed/")
        
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.authorizationStatus() == .Authorized || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
            {
                self.locationManager.startUpdatingLocation()
            }
            else
            {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        else
        {
            println("Location services are not enabled")
        }
     
    }
    
    
    
//MARK: Locations Delegate methods
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch status {
        case .Authorized:
            self.locationManager.startUpdatingLocation()
        case .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .Denied:
            println("Location services disabled for this app")
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .Restricted:
            println("Location servers restricted on this device")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        self.locationManager.stopUpdatingLocation()
        
        if error != nil
        {
            println("There was an error getting the device location: \(error)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        self.myLatitude  = self.locationManager.location.coordinate.latitude
        self.myLongitude = self.locationManager.location.coordinate.longitude
        
        if self.myLatitude != nil && self.myLongitude != nil
        {
            NSNotificationCenter.defaultCenter().postNotificationName(self.kLocationDidUpdateNotification, object: nil, userInfo: ["lat": self.myLatitude!, "lon": self.myLongitude!])
            
        }
        
        if self.locationManager.location.horizontalAccuracy <= 50
        {
            self.locationManager.stopUpdatingLocation()
            println("stop updating location")
        }
        
        
        
    }
    
//MARK:
    
    
    
    func getMyLocation(completionHandler:(myCords:(longitude: String, latitude: String)) ->(Void))
    {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.myLatitude != nil && self.myLongitude != nil
            {
                completionHandler(myCords: ("\(self.myLatitude)", "\(self.myLongitude)"))
            }
            else
            {
                
            }
        })
    }
    
    func getOverHeadPass(latitude: String, longitude: String, completionHandler:(dateTime:[NSDictionary]) ->(Void))
    {
        println("In the overHEAD pass method")
    
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-pass.json?lat=\(latitude)&lon=\(longitude)") { (jsonData) -> (Void) in
           var responseArray = jsonData["response"] as [NSDictionary]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               completionHandler(dateTime: responseArray)
            })
       }
    }
    
    // Gets the current locations from the api and then returns a tuple
    func getCurrentLoctionOfISS(completionHandler:(location:(longitude: Double, latitude: Double, time: String)) ->(Void))
    {
        var longitude: Double?
        var latitude: Double?
        var currentTime: String?
        var currentLocation: (Double?, Double?, Int?)
        
        
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "iss-now.json") { (jsonData) -> (Void) in
            
            var position = jsonData["iss_position"] as NSDictionary
            var unixTime = jsonData["timestamp"] as? Int
            longitude = position["longitude"] as? Double
            latitude = position["latitude"] as? Double
            currentTime = self.dateStringFromUnixtime(unixTime!)
            
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(location: (longitude!, latitude!, currentTime!))
            })
        }
        
    }
    
    func getAstronautList()
    {
        // Downloads the Json Data from the api on a background thread and then when the data comes backs puts it back onto the main queue
        NetworkHelper.downloadJSONData("http://api.open-notify.org/", endPoint: "astros.json") { (jsonData) -> (Void) in
            self.astroDictionary = jsonData
            //println(self.astroDictionary)
            self.astroList = self.createListOfAstronauts(jsonData)
            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                tableView.reloadData()
//            })
        }
    }
    
    // Creates an array of Astronaut objects
    private func createListOfAstronauts(jsonDictionary: NSDictionary) -> [Astronaut]
    {
        // An array from the Json Data dicitonary
        let astronautArray = jsonDictionary["people"] as NSArray
        var astronautList: [Astronaut] = []
        
        for astronaut in astronautArray
        {
            // This will break if new people come to the ISS 
            switch astronaut["name"] as String
            {
                case "Alexander Samokutyaev":
                    var profileImage = UIImage(named: "Alex")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!, astronautInfoDict: self.createAstronautInfoDict("Born March 13, 1970, in Penza, Russia. Married to Samokutyaeva (nee Zosimova) Oksana Nikolaevna. They have one daughter, Anastasia, born in 1995. His parents, Maikhail Nikolaevich and Maria Alexandrovna Samokutyaev, reside in Penza. Hobbies include ice hockey, traveling",
                        education: "Graduated from the Chernigov Air Force Pilot School as pilot-engineer in 1992, and in 2000 from the Gagarin Air Force Academy.",
                        awards: "Recipient of various Russian Armed Force medals.",
                        experience: "Samokutyaev flew Vilga-35A,-L-13 Blanik, L-39, SU-24? aircraft as pilot, senior pilot and deputy commander of air squadron. Samokutyaev has logged 680 hours of flight time and performed 250 parachute jumps. He is a Class 3 Air Force pilot and a qualified diver. After graduation from the Academy he was appointed as GCTC 2nd division department chief.") )
                    astronautList.append(newAstronaut)
                case "Elena Serova":
                    var profileImage = UIImage(named: "elena")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!, astronautInfoDict: self.createAstronautInfoDict("Born April 22, 1976, in Vozdvizhenka, Ussurijsk Region of Primorsky Area, Russia.",
                        education: "In March 2001 graduated from aerospace department of the Moscow Aviation Institute as a test engineer.In 2003 graduated from the Moscow State Academy of instrument-making and information as an economist. ",
                        awards: "",
                        experience: "Prior to selection to the Cosmonaut Corps Serova worked as a 2nd category engineer at the Energia Rocket Space Corporation and the MCC-Moscow. COSMONAUT SELECTION DATE AND CLASS: On October 11, 2006, the Interdepartmental Board recommended that she be assigned to the Energia Rocket/Space Corporation Cosmonaut Corps as a cosmonaut candidate. In February 2007 she started a two-year course of basic training for spaceflight. In December 2006 by the order of the Ministry of Defense she was assigned to the GCTC Cosmonaut Corps as a test cosmonaut candidate. On June 9, 2009, the Interdepartmental Board certified her as a test cosmonaut of the Energia Rocker and Space Corporation. SCIENCE ACTIVITIES: Completed a postgraduate course at the Energia Rocket Space Corporation (extramural training)."))
                    
                    astronautList.append(newAstronaut)
                case "Barry Wilmore":
                    var profileImage = UIImage(named: "Barry")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!, astronautInfoDict: self.createAstronautInfoDict("He is married to the former Miss Deanna Newport of Helenwood, Tennessee and they have two daughters. He was raised in Mt. Juliet, Tennessee where his parents Eugene and Faye Wilmore still reside. His brother Jack and family reside in Franklin, Tennessee.",
                        education: "Bachelor of Science and Master of Science in Electrical Engineering, Tennessee Technological University. Master of Science in Aviation Systems, University of Tennessee. Mount Juliet High School, Mount Juliet, Tennesee.",
                        awards: "Navy Meritorious Service Medal, five Air Medals, three with Combat 'V' designation. Six Navy Commendation Medal, three of which also hold the Combat 'V' designation. Two Navy Achievement Medal and numerous unit decorations. Aviation Officer Candidate School (AOCS) “Distinguished Naval Graduate.” Initial Naval Flight Training “Commodores List with Distinction.” United States Atlantic Fleet “Light Attack Wing One - Pilot of the Year” (1991). U.S. Atlantic Fleet \"Strike Fighter Aviator of the Year\" (1999). Recipient of the Strike Fighter Wing Atlantic “Scott Speicher Award” for Weapons Employment Excellence (1998). Tennessee Technological University “Sports Hall of Fame” Inductee for football (2003). Tennessee Technological University Outstanding Alumus and Engineer of Distinction (2010). Honorary Doctorate, Tennessee Technological University (2012)",
                        experience: "Wilmore has accumulated more than 6800 flight hours and 663 carrier landings, all in tactical jet aircraft, and is a graduate of the United States Naval Test Pilot School (USNTPS). During his tenure as a fleet Naval officer and pilot, Wilmore completed four operational deployments, flying the A-7E and FA 18 aircraft from the decks of the USS Forrestal, USS Kennedy, USS Enterprise and the USS Eisenhower aircraft carriers. He has flown missions in support of Operations Desert Storm, Desert Shield and Southern Watch over the skies of Iraq, as well as missions over Bosnia in support of United States and NATO interests. Wilmore successfully completed 21 combat missions during Operation Desert Storm while operating from the flight deck of the USS Kennedy. His most recent operational deployment was aboard the USS Eisenhower with the \"Blue Blasters\" of Strike Fighter Squadron 34 (VFA-34), an F/A-18 squadron based at Naval Air Station Oceana, Virginia. As a Navy test pilot, Wilmore participated in all aspects of the initial development of the T-45 jet trainer to include initial carrier landing certification and high angle of attack flight tests. His test tour also included a stint at USNTPS as a systems and fixed wing Flight Test Instructor. Prior to his selection to NASA, Wilmore was on exchange to the United States Air Force as a Flight Test Instructor at the Air Force Test Pilot School at Edwards Air Force Base, California. NASA EXPERIENCE:  Selected as an astronaut by NASA in July 2000, Wilmore reported for training in August 2000. Following the completion of two years of training and evaluation, he was assigned technical duties representing the Astronaut Office on all propulsion systems issues including the space shuttle main engines, solid rocket motor, external tank, and also led the astronaut support team that traveled to NASA’s Kennedy Space Center, Florida, in support of launch and landing operations. He completed his first flight as pilot on STS-129 and has logged more than 259 hours in space. SPACE FLIGHT EXPERIENCE: STS-129 (November 16 - 29, 2009) was the 31st shuttle flight to the International Space Station. During the mission, the crew delivered two Express Logistics Carrier (ELC racks) and about 30,000 pounds of replacement parts to maintain the station’s proper orientation in space. The mission also featured three spacewalks. The STS-129 mission was completed in 10 days, 19 hours, 16 minutes and 13 seconds, traveling 4.5 million miles in 171 orbits, and returned to Earth bringing back with them NASA astronaut, Nicole Stott, following her tour of duty aboard the station. In September of 2014, Wilmore is scheduled to launch from the Baikonur on Cosmodrome, Kazakstan Soyuz 40S to the International Space Station. Wilmore is scheduled to assume command of the station in November 2014."))
                    astronautList.append(newAstronaut)
                case "Anton Schkaplerov":
                    var profileImage = UIImage(named: "Anton")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!, astronautInfoDict: self.createAstronautInfoDict("Born February 20, 1972, in Sevastopol. His parents, Nikolay Ivanovich Shkaplerov and Tamara Viktorovna Shkaplerova, reside in Sevastopol, in the Crimea. Anton is married to Tatyana Petrovna, and they have two daughters named Kristina and Kira. His hobbies include sports, travel, fishing and golf.",
                        education: "Shkaplerov completed Yak-52 flight training at the Sevastopol Aviation Club in 1989. After graduation from Sevastopol High School in 1989, he entered the Kachinsk Air Force Pilot School graduating in 1994 as pilot-engineer. He graduated from the N. E. Zukovskiy Air Force Engineering in 1997.",
                        awards: "",
                        experience: "After graduation from the academy he served as a senior pilot-instructor in the Russian Air Force. He flew 3 different types of aircraft: Yak-52, L-29 and MiG-29. He is a Class 2 Air Force pilot-instructor. He is also an Instructor of General Parachute Training, and has performed more than 300 parachute jumps.hkaplerov was selected as a test-cosmonaut candidate of the Gagarin Cosmonaut Training Center Cosmonaut Office in May 2003. From June 2003 to June 2005 he attended basic space training. In 2005 Shkaplerov was qualified as a test cosmonaut.From April-October 2007, Shkaplerov served as Director of Operations, Russian Space Agency, stationed at the Johnson Space Center in Houston, Texas. Anton is currently assigned as a back-up commander for Expedition 22."))
                    
                    astronautList.append(newAstronaut)
                case "Samantha Cristoforetti":
                    var profileImage = UIImage(named: "Sam")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!,astronautInfoDict: self.createAstronautInfoDict("Born in Milan, Italy, on 26 April 1977, Samantha Cristoforetti enjoys hiking, scuba diving, yoga, reading and travelling. Other interests include technology, nutrition and the Chinese language.",
                        education: "Samantha completed her secondary education at the Liceo Scientifico in Trento, Italy, in 1996 after having spent a year as an exchange student in the United States. In 2001, she graduated from the Technische Universität Munich, Germany, with a master’s degree in mechanical engineering with specialisations in aerospace propulsion and lightweight structures. As part of her studies, she spent four months at the Ecole Nationale Supérieure de l’Aéronautique et de l’Espace in Toulouse, France, working on an experimental project in aerodynamics. She wrote her master’s thesis in solid rocket propellants during a 10-month research stay at the Mendeleev University of Chemical Technologies in Moscow, Russia. As part of her training at the Italian Air Force Academy, she also completed a bachelor’s degree in aeronautical sciences at the University of Naples Federico II, Italy, in 2005.",
                        awards: "",
                        experience: "In 2001 Samantha joined the Italian Air Force Academy in Pozzuoli, Italy, graduating in 2005. She served as class leader and was awarded the Honour Sword for best academic achievement. From 2005 to 2006, she was based at Sheppard Air Force Base in Texas, USA. After completing the Euro-NATO Joint Jet Pilot Training, she became a fighter pilot and was assigned to the 132nd Squadron, 51st Bomber Wing, based in Istrana, Italy. In 2007, Samantha completed Introduction to Fighter Fundamentals training. From 2007 to 2008, she flew the MB-339 and served in the Plan and Operations Section for the 51st Bomber Wing in Istrana, Italy. In 2008, she joined the 101st Squadron, 32nd Bomber Wing, based at Foggia, Italy, where she completed operational conversion training for the AM-X ground attack fighter. Samantha is a Captain in the Italian Air Force. She has logged over 500 hours flying six types of military aircraft: SF-260, T-37, T-38, MB-339A, MB-339CD and AM-X. Samantha was selected as an ESA astronaut in May 2009. She joined ESA in September 2009 and completed basic astronaut training in November 2010. In July 2012 she was assigned to an Italian Space Agency ASI mission aboard the International Space Station. She was launched on a Soyuz spacecraft from Baikonur Cosmodrome in Kazakhstan on 23 November 2014 on the second long-duration ASI mission and the eighth long-duration mission for an ESA astronaut. Samantha is now working and living on the International Space Station as part of her Futura mission and enjoys interacting with space enthusiasts on Twitter as @AstroSamantha."))
                    astronautList.append(newAstronaut)
                case "Terry Virts":
                    var profileImage = UIImage(named: "Terry")
                    var newAstronaut: Astronaut = Astronaut(name: astronaut["name"]! as String, craft: astronaut["craft"]! as String, image: profileImage!,astronautInfoDict: self.createAstronautInfoDict("Born in December 1967, in Baltimore, Maryland, but considers Columbia, Maryland, to be his hometown.  Married with two children.  Virts enjoys baseball, astronomy and coaching youth sports.",
                        education: "Oakland Mills High School, Columbia, Maryland, 1985 B.S., Mathematics (French minor), U.S. Air Force Academy, 1989 M.A.S., Aeronautics, Embry-Riddle Aeronautical University, 1997 General Management Program, Harvard Business School, 2011",
                        awards: "Graduated with Academic Distinction from the United States Air Force Academy and Embry-Riddle Aeronautical University;  Distinguished Graduate of Undergraduate Pilot Training at Williams Air Force Base, Arizona, and F-16 training at Macdill Air Force Base, Florida.  Military decorations include the NASA Space Flight Medal, Defense Meritorious Service Medal, Meritorious Service Medal, Air Medal, Aerial Achievement Medal, NASA Exceptional Achievement Medal, Air Force Commendation Medal, et al.",
                        experience: "Virts attended the Ecole de l’Air (French Air Force Academy) in 1988 on an exchange program from the United States Air Force Academy.  He received his commission as a Second Lieutenant upon graduation from the United States Air Force Academy in 1989.  He earned his pilot wings from Williams Air Force Base, Arizona, in 1990.  From there, Virts completed basic fighter and F-16 training and was assigned to Homestead Air Force Base, Florida, as an operational F-16 pilot in the 307th Tactical Fighter Squadron.  After Hurricane Andrew struck Homestead in 1992, his squadron was moved to Moody Air Force Base, Georgia.  From 1993 to 1994, he served in the 36th Fighter Squadron at Osan Air Base, Republic of Korea, where he flew low-altitude night attack missions in the F-16.  Following his tour in Korea, he was reassigned to the 22nd Fighter Squadron at Spangdahlem Air Base, Germany, from 1995 to 1998.  There, he flew the suppression of enemy air defenses missions, logging 45 combat missions in the F-16.  Virts was a member of the United States Air Force Test Pilot School class 98B at Edwards Air Force Base, California.  Following graduation, he was an Experimental Test Pilot at the F-16 Combined Test Force at Edwards from 1999 until his selection as a member of the 18th group of astronaut candidates in 2000. While at Edwards he served as the chief test pilot for the F-16 HARM Targeting System (HTS) as well as the Multi-Mission Computer (MMC) programs, the largest upgrade program in the 40-year history of the F-16. He has logged over 4,300 flight hours in more than 40 different aircraft. NASA EXPERIENCE:  Selected as a pilot by NASA in July 2000, Virts reported for training in August 2000.  His technical assignments to date have included Lead Astronaut for the T-38 program, Shuttle Avionics Integration Laboratory (SAIL) test crew member, Expedition 9 Crew Support Astronaut and lead astronaut for appearances.  He has worked as a Capsule Communicator (CAPCOM) from Expedition 8 to 19 as well as STS-115 to STS-126, communicating with station and shuttle crews from Mission Control in Houston.  He also served as the lead Ascent and Entry CAPCOM, Chief of the Astronaut Office Robotics Branch and lead astronaut for the Space Launch System heavy lift booster. SPACEFLIGHT EXPERIENCE STS-130 pilot, Endeavour (February 8 to February 21, 2010), carrying aloft the International Space Station’s final permanent modules: Tranquility and Cupola.  Tranquility (or Node 3) is now the life-support hub of the space station, containing exercise, water recycling and environmental control systems, while the Cupola provides the largest set of windows ever flown in space.  These seven windows, which are arranged in a hemisphere, provide a spectacular and panoramic view of our planet and afford crews a direct view of station robotic operations. As pilot, Virts was responsible for assisting Commander George Zamka during launch, landing, rendezvous and orbital maneuvering.  He was also the mission’s lead robotic operator and was responsible for much of the internal outfitting of Tranquility and Cupola.  During the 13-day, 18-hour mission, Endeavour traveled more than 5.7 million miles and completed 217 orbits of the Earth. Virts is currently assigned to Expedition 42/43, as commander for Expedition 43, which is scheduled to launch on a Russian Soyuz in December 2014, with a planned landing in May 2015."))
                    astronautList.append(newAstronaut)
                default:
                    var profileImage = UIImage(named: "noImage")
                    var newAstronaut: Astronaut = Astronaut(name: "Jonny Astronaut" as String, craft: "The X-wing" as String, image: profileImage!,astronautInfoDict: self.createAstronautInfoDict("Some personal info",
                        education: "some education",
                        awards: "some awards",
                        experience: "some experience"))
                    astronautList.append(newAstronaut)
            }
            
            
        }
        
        return astronautList
    }
    

    
//MARK: Helpers
    
    // Formats a unix time into a human readable time
    func dateStringFromUnixtime(unixTime: Int) -> String
    {
        let timeInSeconds = NSTimeInterval(unixTime)
        let date = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .LongStyle
        
        return dateFormatter.stringFromDate(date)
    }
    
    private func createAstronautInfoDict(personalData: String, education: String, awards: String,  experience: String) -> [NSDictionary]
    {
        return [["personalData":personalData], ["education":education], ["awards":awards], ["experience":experience]]
    }
    
    
    
}