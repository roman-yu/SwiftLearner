//
//  ViewController.swift
//  SwiftLearner
//
//  Created by Chen YU on 15/10/15.
//  Copyright © 2015 Chen YU. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cellIdentifier = "cell"

    var scope = "All"
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    
    var tableView : UITableView = UITableView ()
    var searchBar : UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sample Data for candyArray
        self.candies = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView)
        
        searchBar.placeholder = "Your placeholder"
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Layout
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        let height: CGFloat? = self.navigationController?.navigationBar.frame.size.height
    
        print(height!)
//        let height: CGFloat = 10.0
        
        // Add custom view sizing constraints here
        tableView.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: height!)
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
    }

    // MARK: Private
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredCandies = self.candies.filter({( candy: Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteredCandies.count > 0 {
            return self.filteredCandies.count;
        } else {
            return self.candies.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        // Get the corresponding candy from our candies array
        
        var candy : Candy
        if self.filteredCandies.count > 0 {
            candy = self.filteredCandies[indexPath.row]
        } else {
            candy = self.candies[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newString = (searchBar.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        self.filterContentForSearchText(newString)
        return true
    }

}

