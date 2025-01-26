import Foundation

// 더미 데이터
let dummyTrendingMovies = TrendingDTO(
    page: 1,
    results: [
        ResultsDTO(
            id: 939243,
            backdrop_path: "/b85bJfrTOSJ7M5Ox0yp4lxIxdG1.jpg",
            title: "수퍼 소닉 3",
            overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자...",
            poster_path: "/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg",
            genre_ids: [28, 878, 35, 10751],
            release_date: "2024-12-19",
            vote_average: 7.823
        ),
        ResultsDTO(
            id: 1114894,
            backdrop_path: "/3SOunz2Z0qcOVlrkYFj20HquziB.jpg",
            title: "스타 트렉: 섹션 31",
            overview: "섹션 31의 비밀 작전을 다룬 이야기.",
            poster_path: "/sqiCinCzUGlzQiFytS30N1nO3Pt.jpg",
            genre_ids: [878, 12, 28, 18],
            release_date: "2025-01-15",
            vote_average: 4.883
        ),
        ResultsDTO(
            id: 426063,
            backdrop_path: "/fYnEbgoNCxW9kL0IgOgtJb9JTBU.jpg",
            title: "노스페라투",
            overview: "오랜 시간 통제할 수 없는 강력한 힘에 이끌려 악몽과 괴로움에 시달려 온 엘렌...",
            poster_path: "/xeiARSpxGdVCw5KkCDgj31MO45o.jpg",
            genre_ids: [27, 14],
            release_date: "2024-12-25",
            vote_average: 6.616
        ),
        ResultsDTO(
            id: 728949,
            backdrop_path: "/2ICMZZVcwboF8Z9V7aaJY3CVh9w.jpg",
            title: "나이트비치",
            overview: "한 여성이 전업주부가 되면서 예상치 못한 변화를 겪는 이야기.",
            poster_path: "/dDB71usg620D9RhgL3Rk8LhKc5j.jpg",
            genre_ids: [35, 27],
            release_date: "2024-12-06",
            vote_average: 6.0
        ),
        ResultsDTO(
            id: 507241,
            backdrop_path: "/zGLQmrmIB56kMZPnzqReIOBay1B.jpg",
            title: "킬러의 게임",
            overview: "최고의 암살자가 자신의 암살을 의뢰하게 되면서 벌어지는 이야기.",
            poster_path: "/4bKlTeOUr5AKrLky8mwWvlQqyVd.jpg",
            genre_ids: [28, 35, 80],
            release_date: "2024-09-12",
            vote_average: 6.5
        ),
        ResultsDTO(
            id: 939243,
            backdrop_path: "/b85bJfrTOSJ7M5Ox0yp4lxIxdG1.jpg",
            title: "수퍼 소닉 3",
            overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자...",
            poster_path: "/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg",
            genre_ids: [28, 878, 35, 10751],
            release_date: "2024-12-19",
            vote_average: 7.823
        ),
        ResultsDTO(
            id: 1114894,
            backdrop_path: "/3SOunz2Z0qcOVlrkYFj20HquziB.jpg",
            title: "스타 트렉: 섹션 31",
            overview: "섹션 31의 비밀 작전을 다룬 이야기.",
            poster_path: "/sqiCinCzUGlzQiFytS30N1nO3Pt.jpg",
            genre_ids: [878, 12, 28, 18],
            release_date: "2025-01-15",
            vote_average: 4.883
        ),
        ResultsDTO(
            id: 426063,
            backdrop_path: "/fYnEbgoNCxW9kL0IgOgtJb9JTBU.jpg",
            title: "노스페라투",
            overview: "오랜 시간 통제할 수 없는 강력한 힘에 이끌려 악몽과 괴로움에 시달려 온 엘렌...",
            poster_path: "/xeiARSpxGdVCw5KkCDgj31MO45o.jpg",
            genre_ids: [27, 14],
            release_date: "2024-12-25",
            vote_average: 6.616
        ),
        ResultsDTO(
            id: 728949,
            backdrop_path: "/2ICMZZVcwboF8Z9V7aaJY3CVh9w.jpg",
            title: "나이트비치",
            overview: "한 여성이 전업주부가 되면서 예상치 못한 변화를 겪는 이야기.",
            poster_path: "/dDB71usg620D9RhgL3Rk8LhKc5j.jpg",
            genre_ids: [35, 27],
            release_date: "2024-12-06",
            vote_average: 6.0
        ),
        ResultsDTO(
            id: 507241,
            backdrop_path: "/zGLQmrmIB56kMZPnzqReIOBay1B.jpg",
            title: "킬러의 게임",
            overview: "최고의 암살자가 자신의 암살을 의뢰하게 되면서 벌어지는 이야기.",
            poster_path: "/4bKlTeOUr5AKrLky8mwWvlQqyVd.jpg",
            genre_ids: [28, 35, 80],
            release_date: "2024-09-12",
            vote_average: 6.5
        ),
        ResultsDTO(
            id: 939243,
            backdrop_path: "/b85bJfrTOSJ7M5Ox0yp4lxIxdG1.jpg",
            title: "수퍼 소닉 3",
            overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자...",
            poster_path: "/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg",
            genre_ids: [28, 878, 35, 10751],
            release_date: "2024-12-19",
            vote_average: 7.823
        ),
        ResultsDTO(
            id: 1114894,
            backdrop_path: "/3SOunz2Z0qcOVlrkYFj20HquziB.jpg",
            title: "스타 트렉: 섹션 31",
            overview: "섹션 31의 비밀 작전을 다룬 이야기.",
            poster_path: "/sqiCinCzUGlzQiFytS30N1nO3Pt.jpg",
            genre_ids: [878, 12, 28, 18],
            release_date: "2025-01-15",
            vote_average: 4.883
        ),
        ResultsDTO(
            id: 426063,
            backdrop_path: "/fYnEbgoNCxW9kL0IgOgtJb9JTBU.jpg",
            title: "노스페라투",
            overview: "오랜 시간 통제할 수 없는 강력한 힘에 이끌려 악몽과 괴로움에 시달려 온 엘렌...",
            poster_path: "/xeiARSpxGdVCw5KkCDgj31MO45o.jpg",
            genre_ids: [27, 14],
            release_date: "2024-12-25",
            vote_average: 6.616
        ),
        ResultsDTO(
            id: 728949,
            backdrop_path: "/2ICMZZVcwboF8Z9V7aaJY3CVh9w.jpg",
            title: "나이트비치",
            overview: "한 여성이 전업주부가 되면서 예상치 못한 변화를 겪는 이야기.",
            poster_path: "/dDB71usg620D9RhgL3Rk8LhKc5j.jpg",
            genre_ids: [35, 27],
            release_date: "2024-12-06",
            vote_average: 6.0
        ),
        ResultsDTO(
            id: 507241,
            backdrop_path: "/zGLQmrmIB56kMZPnzqReIOBay1B.jpg",
            title: "킬러의 게임",
            overview: "최고의 암살자가 자신의 암살을 의뢰하게 되면서 벌어지는 이야기.",
            poster_path: "/4bKlTeOUr5AKrLky8mwWvlQqyVd.jpg",
            genre_ids: [28, 35, 80],
            release_date: "2024-09-12",
            vote_average: 6.5
        ),
        ResultsDTO(
            id: 939243,
            backdrop_path: "/b85bJfrTOSJ7M5Ox0yp4lxIxdG1.jpg",
            title: "수퍼 소닉 3",
            overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자...",
            poster_path: "/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg",
            genre_ids: [28, 878, 35, 10751],
            release_date: "2024-12-19",
            vote_average: 7.823
        ),
        ResultsDTO(
            id: 1114894,
            backdrop_path: "/3SOunz2Z0qcOVlrkYFj20HquziB.jpg",
            title: "스타 트렉: 섹션 31",
            overview: "섹션 31의 비밀 작전을 다룬 이야기.",
            poster_path: "/sqiCinCzUGlzQiFytS30N1nO3Pt.jpg",
            genre_ids: [878, 12, 28, 18],
            release_date: "2025-01-15",
            vote_average: 4.883
        ),
        ResultsDTO(
            id: 426063,
            backdrop_path: "/fYnEbgoNCxW9kL0IgOgtJb9JTBU.jpg",
            title: "노스페라투",
            overview: "오랜 시간 통제할 수 없는 강력한 힘에 이끌려 악몽과 괴로움에 시달려 온 엘렌...",
            poster_path: "/xeiARSpxGdVCw5KkCDgj31MO45o.jpg",
            genre_ids: [27, 14],
            release_date: "2024-12-25",
            vote_average: 6.616
        ),
        ResultsDTO(
            id: 728949,
            backdrop_path: "/2ICMZZVcwboF8Z9V7aaJY3CVh9w.jpg",
            title: "나이트비치",
            overview: "한 여성이 전업주부가 되면서 예상치 못한 변화를 겪는 이야기.",
            poster_path: "/dDB71usg620D9RhgL3Rk8LhKc5j.jpg",
            genre_ids: [35, 27],
            release_date: "2024-12-06",
            vote_average: 6.0
        ),
        ResultsDTO(
            id: 507241,
            backdrop_path: "/zGLQmrmIB56kMZPnzqReIOBay1B.jpg",
            title: "킬러의 게임",
            overview: "최고의 암살자가 자신의 암살을 의뢰하게 되면서 벌어지는 이야기.",
            poster_path: "/4bKlTeOUr5AKrLky8mwWvlQqyVd.jpg",
            genre_ids: [28, 35, 80],
            release_date: "2024-09-12",
            vote_average: 6.5
        )
    ]
)

