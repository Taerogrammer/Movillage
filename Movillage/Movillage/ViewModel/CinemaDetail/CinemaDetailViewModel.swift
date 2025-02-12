import Foundation

final class CinemaDetailViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private(set) var detailSection = ["", "Synopsis", "Cast", "Poster"]

    struct Input {
        let backdropArray: Observable<[String]?> = Observable(nil)
        let posterArray: Observable<[String]?> = Observable(nil)
        let footerDTO: Observable<FooterDTO> = Observable(FooterDTO(id: 0, title: "", overview: "", genre_ids: [], release_date: "", vote_average: 0.0))
        let synopsisDTO: Observable<String> = Observable("")
        let castDTO: Observable<[CastResponse]?> = Observable(nil)

    }
    struct Output {
        let backdropArray: Observable<[String]?> = Observable(nil)
        let posterArray: Observable<[String]?> = Observable(nil)
        let footerDTO: Observable<FooterDTO> = Observable(FooterDTO(id: 0, title: "", overview: "", genre_ids: [], release_date: "", vote_average: 0.0))
        let synopsisDTO: Observable<String> = Observable("")
        let castDTO: Observable<[CastResponse]?> = Observable(nil)
    }
    init() {
        input = Input()
        output = Output()

        transform()
    }
    func transform() {
        input.backdropArray.bind { [weak self] array in
            self?.output.backdropArray.value = array
        }
        input.posterArray.bind { [weak self] array in
            self?.output.posterArray.value = array
        }
        input.footerDTO.lazyBind { [weak self] data in
            self?.output.footerDTO.value = data
        }
        input.synopsisDTO.lazyBind { [weak self] data in
            self?.output.synopsisDTO.value = data
        }
        input.castDTO.lazyBind { [weak self] data in
            self?.output.castDTO.value = data
        }
    }
}
