//
//  Swinject+Operators.swift
//  Pods
//
//  Created by Tomas Kohout on 8/30/16.
//  Copyright © 2016 Swinject Contributors. All rights reserved.
//

import Swinject
import Foundation

//Already declared in Swift
//infix operator ~> { associativity left precedence 160 }
postfix operator ~>

/** Unary operator which automatically resolves the return type
 Usage: `SomeClass(dependencyA: r~>, dependencyB: r~>)`
 - Parameters:
 - r: Resolver
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public postfix func ~> <Service>(r: Resolver) -> Service {
    return r.resolve(Service.self)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type)!`
 
 Usage: `SomeClass(dependencyA: r ~> DependencyA.self)`
 - Parameters:
 - r: Resolver
 - service: Type of service to resolve.
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service>(r: Resolver, service: Service.Type) -> Service {
    return r.resolve(service)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type, name: "ServiceName")!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, name: "ServiceName"))`
 - Parameters:
 - r: Resolver
 - service: Type of service to resolve.
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service>(r: Resolver, o: (service: Service.Type, name: String)) -> Service {
    return r.resolve(o.service, name: o.name)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type, argument: Arg1)!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, argument: arg))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.argument: Argument to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1>(r: Resolver, o: (service: Service.Type, argument: Arg1) ) -> Service {
    return r.resolve(o.service, argument: o.argument)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type, name: String, argument: Arg1)!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, name: "ServiceName", argument: arg))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.argument: Argument to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1>(r: Resolver, o: (service: Service.Type, name: String, argument: Arg1) ) -> Service {
    return r.resolve(o.service, name: o.name, argument: o.argument)!
}

//@available(*, deprecated, message: "Arguments passed in sequence have been deprecated, pass arguments in tuple instead. e.g: ~> (Service.self, arguments: (arg1, arg2))")
//public func ~> <Service, Arg1: Any, Arg2: Any>(r: Resolver, o: (Service.Type, arguments: Arg1, Arg2) ) -> Service {
//    return r.resolve(o.0, arguments: o.1, o.2)!
//}

@available(*, deprecated, message: "Comma-separated arguments have been deprecated, pass arguments in tuple instead. e.g: ~> (Service.self, name: \"Service\", arguments: (arg1, arg2))")
public func ~> <Service, Arg1, Arg2>(r: Resolver, o: (Service.Type, name: String, arguments: Arg1, Arg2) ) -> Service {
    return r.resolve(o.0, name: o.1, arguments: o.2, o.3)!
}

@available(*, deprecated, message: "Comma-separated arguments have been deprecated, pass arguments in tuple instead. e.g: ~> (Service.self, arguments: (arg1, arg2, arg3))")
public func ~> <Service, Arg1, Arg2, Arg3>(r: Resolver, o: (Service.Type, arguments: Arg1, Arg2, Arg3) ) -> Service {
    return r.resolve(o.0, arguments: o.1, o.2, o.3)!
}

@available(*, deprecated, message: "Comma-separated arguments have been deprecated, pass arguments in tuple instead. e.g: ~> (Service.self, name: \"Service\", arguments: (arg1, arg2, arg3))")
public func ~> <Service, Arg1, Arg2, Arg3>(r: Resolver, o: (Service.Type, name: String, arguments: Arg1, Arg2, Arg3) ) -> Service {
    return r.resolve(o.0, name: o.1, arguments: o.2, o.3, o.4)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type, arguments: (Arg1, Arg2))!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, arguments: (arg1, arg2)))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.arguments: Arguments to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1, Arg2>(r: Resolver, o: (Service.Type, arguments: (Arg1, Arg2)) ) -> Service {
    return r.resolve(o.0, arguments: o.arguments.0, o.arguments.1)!
}


/** Binary operator ~> equivalent to `r.resolve(Service.Type, name: "ServiceName", arguments: (Arg1, Arg2))!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, name: "ServiceName", arguments: (arg1, arg2)))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.arguments: Arguments to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1, Arg2>(r: Resolver, o: (Service.Type, name: String, arguments: (Arg1, Arg2)) ) -> Service {
    return r.resolve(o.0, name: o.1, arguments: o.arguments.0, o.arguments.1)!
}


/** Binary operator ~> equivalent to `r.resolve(Service.Type, arguments: (Arg1, Arg2, Arg3))!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, arguments: (arg1, arg2, arg3)))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.arguments: Arguments to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1, Arg2, Arg3>(r: Resolver, o: (Service.Type, arguments: (Arg1, Arg2, Arg3)) ) -> Service {
    return r.resolve(o.0, arguments: o.arguments.0, o.arguments.1, o.arguments.2)!
}

/** Binary operator ~> equivalent to `r.resolve(Service.Type, name: "ServiceName", arguments: (Arg1, Arg2, Arg3))!`
 
 Usage: `SomeClass(dependencyA: r ~> (DependencyA.self, name: "ServiceName", arguments: (arg1, arg2, arg3)))`
 - Parameters:
 - r: Resolver
 - o.service: Type of service to resolve.
 - o.arguments: Arguments to pass
 
 - Returns: The resolved service type instance.
 - Important: Fails on unresolvable service.
 */
public func ~> <Service, Arg1, Arg2, Arg3>(r: Resolver, o: (Service.Type, name: String, arguments: (Arg1, Arg2, Arg3)) ) -> Service {
    return r.resolve(o.0, name: o.1, arguments: o.arguments.0, o.arguments.1, o.arguments.2)!
}
