//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable{

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    
    
    static var taskKey: String {
        return "TaskKey"
    }

    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task],forKey key: String) {

        // TODO: Save the array of tasks
        let  defaults = UserDefaults.standard
        
        let encodeData = try! JSONEncoder().encode(tasks)
        
        defaults.set(encodeData, forKey: key)
        
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks(forKey key: String) -> [Task] {
       
        let defaults = UserDefaults.standard
        // TODO: Get the array of saved tasks from UserDefaults
        if let data = defaults.data(forKey: key) {
            let decodedTasks = try! JSONDecoder().decode([Task].self, from: data)
            return decodedTasks
        }
  return [] // 👈 replace with returned saved tasks
    }

    // Add a new task or update an existing task with the current task.
    func save(forKey key: String) {
        
    // TODO: Save the current task
        
        var tasks = Task.getTasks(forKey: Task.taskKey)
          
          // Check if the task with the same ID already exists in the array
          if let index = tasks.firstIndex(where: { $0.id == self.id }) {
              // Remove the existing task from the array
              tasks.remove(at: index)
              // Insert the updated task in place of the removed task
              tasks.insert(self, at: index)
          } else {
              // If no matching task exists, add the new task to the end of the array
              tasks.append(self)
          }
          
          // Save the updated tasks array back to UserDefaults using the provided key
        Task.save(tasks, forKey: Task.taskKey)
        
        }
}
