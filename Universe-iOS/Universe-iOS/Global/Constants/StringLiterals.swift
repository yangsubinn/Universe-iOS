//
//  StringLiterals.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import Foundation

struct I18N {
    struct Login {
        static let login = "로그인"
        static let socialLogin = "간편로그인"
        static let notMember = "아직 회원이 아니신가요?"
        static let findPassword = "비밀번호 찾기"
        static let checkAccountInfo = "계정 정보를 확인해주세요"
    }
    
    struct Default {
        static let delete = "삭제"
        static let cancel = "취소"
        static let ok = "확인"
        static let no = "아니오"
        static let pixelcastUniverse = "Pixelcast Universe"
        static let more = "더보기"
    }
    
    struct Error {
        static let error = "에러"
        static let networkError = "네트워크가 원활하지 않습니다."
        static let networkErrorDescription = "인터넷 연결을 확인하고 다시 시도해 주세요."
        static let temporaryError = "일시적인 오류가 발생했습니다."
        static let temporaryErrorDescription = "잠시 후 다시 시도해 주세요."
        static let duplicatedRequest = "이미 다른 유저에 의해 진행된 작업입니다."
        static let duplicatedRequestDescription = "다시 접속해 주세요."
    }
    
    struct Community {
        static let leagueName = "2023 PCU League Season 1"
        static let leagueLocation = "강남 스타디움 1층"
        static let leagueDate = "2023.01.16~2023.3.25"
        static let ingLive = "지금 진행중인 LIVE"
        static let replayLive = "경기 다시보기"
        static let ingEmpty = "진행중인 LIVE가 없습니다!"
        static let replayEmpty = "라이브 경기가 아직 없네요"
    }
    
    struct Button {
        static let badgeOn = "뱃지 달기"
        static let badgeOff = "뱃지 내리기"
        static let toMap = "지도보기"
        static let moreCourt = "코트 더 보기"
    }
    
    struct My {
        static let morePlan = "모든 플랜 보기"
        static let myBadge = "My 뱃지"
        static let notice = "공지사항"
        static let service = "고객센터"
        static let partnership = "제휴문의"
        static let logout = "로그아웃"
        static let noBadge = "아직 획득하지 못한 뱃지입니다.\n아래 조건을 달성하여 배지를 획득해보세요."
        static let logoutSuccess = "로그아웃되었습니다"
    }
    
    struct Plan {
        static let subscribe = "구독"
        static let subscribeProduct = "구독 상품"
        static let paymentMethod = "결제 수단"
        static let basicPlan = "Basic Plan"
        static let basicComposition = "경기 분석 데이터 및 영상 제공"
        static let basicPrice = "9,900원"
        static let standardPlan = "Standard Plan"
        static let standardCompositon = "경기 분석 데이터 및 영상 제공\n+프로 선수 데이터 비교"
        static let standardPrice = "15,000원"
        static let premiumPlan = "Premium Plan"
        static let premiumComposition = "경기 분석 데이터 및 영상 제공\n+프로 선수 데이터 비교\n+개인 맞춤형 코치"
        static let premiumPrice = "20,000원"
        static let personalAgree = "개인정보 제 3자 제공 동의"
        static let termAgree = "약관 동의"
        static let seeMoreButton = "자세히 보기"
    }
    
    struct Stadium {
        static let outdoor = "야외"
        static let indoor = "실내"
    }
    
    struct Play {
        static let playIcon = "play.fill"
        static let backwardIcon = "backward.end.fill"
        static let forwardIcon = "forward.end.fill"
        static let pauseIcon = "pause.fill"
        static let replayIcon = "arrow.clockwise"
        static let sliderIcon = "circle.fill"
        static let maximizeIcon = "viewfinder"
        static let minimizeIcon = "arrow.down.forward.and.arrow.up.backward"
        static let startPlay = "경기 시작"
        static let endPlay = "경기 종료"
        static let startLive = "LIVE 시작"
        static let endLive = "LIVE 종료"
        static let startGame = "게임 시작"
        static let endGame = "게임 종료"
        static let enterPlayerInfo = "선수 정보 입력"
        static let home = "Home"
        static let away = "Away"
        static let start = "시작"
        static let addPlayer = "선수 추가"
        static let delete = "삭제"
        static let QR = "QR인증"
        static let enter = "입장"
        static let camera = "카메라"
        static let changeCamera = "카메라 변경"
        static let endWarning = "경기를 종료하시겠습니까?"
        static let endOngoingSet = "진행중인 세트를 먼저 종료해주세요."
        static let endDescription = "경기 종료 후 메인 화면으로 이동합니다"
        static let alreadyPlaying = "이미 경기 중인 선수가 있습니다."
        static let gameFinished = "게임이 종료되었습니다."
        static let startPlayLong = "게임을 시작합니다."
        static let startFirstGame = "1게임을 시작합니다.\n 경기를 바로 LIVE 하시겠습니까?"
    }
    
    struct Analysis {
        static let onTimeAnalysis = "실시간 경기 분석"
        static let analysis = "분석 통계"
        static let matchAnalysis = "경기별 분석"
        static let emptyMatch = "아직 한 게임도 하지 않으셨네요!\n한 게임 하고 오시죠!"
        static let defaultInfo = "기본 정보"
        static let diagnosis = "경기 진단"
        static let maxScoreGap = "최대 점수 격차"
        static let averageScoreGap = "평균 점수 격차"
        static let averageContinousScore = "평균 연속 득점"
        static let maxSeriesScore = "최대 연속 득점"
        static let averageSeriesScore = "평균 연속 득점"
        static let maxAttackSpeed = "최대 공격 속도"
        static let averageAttackSpeed = "평균 공격 속도"
        static let maxRallyTime = "최장 랠리 시간"
        static let averageRallyTime = "평균 랠리 시간"
        static let scoreInfo = "득점 정보"
        static let pointInfo = "득/실점 정보"
        static let all = "전체"
        static let movement = "동작별"
        static let etc = "기타"
        static let serve = "서브"
        static let returns = "리턴"
        static let forehand = "포핸드"
        static let backhand = "백핸드"
        static let forehandVolley = "포핸드 발리"
        static let backhandVolley = "백핸드 발리"
        static let lob = "로브"
        static let angle = "앵글"
        static let spike = "스파이크"
        static let courtOutScore = "코트아웃 득점"
        static let courtOutLoss = "코트아웃 실점"
    }
}
