//
// ApplicationContext.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class ApplicationContext: Codable {

    public var applicationName: String?
    public var autowireCapableBeanFactory: AutowireCapableBeanFactory?
    public var beanDefinitionCount: Int32?
    public var beanDefinitionNames: [String]?
    public var classLoader: ClassLoader?
    public var displayName: String?
    public var environment: Environment?
    public var id: String?
    public var parent: ApplicationContext?
    public var parentBeanFactory: BeanFactory?
    public var startupDate: Int64?

    public init() {}

}
