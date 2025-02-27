import Foundation
import Moya


class TeamInfoViewModel: ObservableObject {
    @Published var runningLeague: [RunningCompetition] = []
    @Published var squad: [Squad] = []
    @Published var teamInfo: TeamInfoModel?
    @Published var area: Area?
    @Published var coach: Coach?
    @Published var isLoading = true
    
    func fetchTeamInfo(_ teamId: String) {
        isLoading = true
        provider.request(.teamInfo(teamId: teamId)) { result in
            defer { self.isLoading = false }
            switch result {
            case .success(let response):
                do {
                    let teamInfo = try JSONDecoder().decode(TeamInfoModel.self, from: response.data)
                    self.teamInfo = teamInfo
                    self.squad = teamInfo.squad ?? []
                    self.runningLeague = teamInfo.runningCompetitions ?? []
                    self.area = teamInfo.area
                    self.coach = teamInfo.coach
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
