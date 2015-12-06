
public enum Sport {
    case Basketball
    case Soccer
}

func getDescription(sport: Sport)-> String {
    switch sport {
    case .Basketball: return "This is the sport basketball"
    case .Soccer: return "This is the sport Soccer"
    }
}