pragma solidity ^0.8.0;

contract StudentReputation {
    struct Achievement {
        string description;
        uint256 score;
    }
    
    struct Student {
        string name;
        address studentAddress;
        uint256 totalScore;
        uint256 reputationScore;
    }
    
    mapping(address => Achievement[]) private achievements;
    mapping(address => Student) private students;
    
    event StudentRegistered(address indexed student, string name);
    event AchievementAdded(address indexed student, string description, uint256 score);
    
    function registerStudent(string memory name) public {
        require(bytes(students[msg.sender].name).length == 0, "Student already registered");
        students[msg.sender] = Student(name, msg.sender, 0, 0);
        emit StudentRegistered(msg.sender, name);
    }
    
    function addAchievement(address student, string memory description, uint256 score) public {
        require(bytes(students[student].name).length != 0, "Student not registered");
        achievements[student].push(Achievement(description, score));
        students[student].totalScore += score;
        students[student].reputationScore = calculateReputationScore(student);
        emit AchievementAdded(student, description, score);
    }
    
    function calculateReputationScore(address student) internal view returns (uint256) {
        uint256 totalScore = students[student].totalScore;
        if (totalScore < 50) return 1;
        else if (totalScore < 100) return 2;
        else if (totalScore < 200) return 3;
        else if (totalScore < 500) return 4;
        else return 5;
    }
    
    function getAchievements(address student) public view returns (Achievement[] memory) {
        return achievements[student];
    }
    
    function getReputationScore(address student) public view returns (uint256) {
        return students[student].reputationScore;
    }
    
    function getStudentDetails(address student) public view returns (string memory, uint256, uint256) {
        require(bytes(students[student].name).length != 0, "Student not registered");
        return (students[student].name, students[student].totalScore, students[student].reputationScore);
    }
}
