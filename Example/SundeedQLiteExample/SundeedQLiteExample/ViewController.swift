//
//  ViewController.swift
//  SundeedQLiteExample
//
//  Created by Nour Sandid on 10/5/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import UIKit
import SundeedQLite

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let employee = Employee()
        employee.id = "ABCD1"
        employee.firstName = "Nour"
        
        let employer = Employer()
        employer.id = "ABCD-1234-EFGH-5678"
        employer.fullName = "Nour Sandid"
        employer.employees = [employee]
//        employer.save()
        Employee.retrieve { (employees) in
            print(employees.first(where: { $0.id == "ABCD1" })?.firstName)
        }
    }
}

