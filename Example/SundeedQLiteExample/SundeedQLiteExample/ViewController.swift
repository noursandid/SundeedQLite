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
        employee.firstName = "Nour"
        
        let employer = Employer()
        employer.id = "ABCD-1234-EFGH-5678"
        employer.fullName = "Nour Sandid"
        employer.employees = [employee]
        
    }
}

