# KIISE 정보과학회 논문지 LaTeX 양식

ex_paper01.hwp / ex_paper02.doc (정보과학회논문지)에서 추출한 레이아웃 기반 LaTeX class.

## 컴파일
```
xelatex main.tex   # XeLaTeX 필수 (한글 폰트 처리)
```

## 모드
- `\documentclass{kiise}` : 심사용. 저자 정보, 약력 자동 미출력 (투고규정 7-(1), 7-(4))
- `\documentclass[final]{kiise}` : 채택 후. 국문/영문 저자 및 `\biography` 출력

## 측정된 원본 레이아웃 (적용됨)
- 판형 188 x 258 mm, 좌우 여백 21 mm, 상단 38 mm, 하단 18 mm
- 본문 2단, 단 간격 6 mm
- 국문 제목 16pt, 영문 제목 13pt, 본문 9pt, 참고문헌/캡션 8pt
- 장 1. / 절 1.1 (규정 9), 고딕 계열 볼드

## 명령어
| 명령 | 용도 |
|---|---|
| \koreantitle, \englishtitle | 국문/영문 제목 |
| \koreanabstract{...} | 국문 요약 (300~500자) |
| \koreankeywords{...} | 국문 키워드 4~6개 |
| \englishabstract{...} | 영문 요약 (100~200 단어) |
| \englishkeywords{...} | 영문 키워드 4~6개 |
| \figcaption{국문}{영문} | 그림 캡션, 하단 중앙, 한/영 병기 (규정 10) |
| \tabcaption{국문}{영문} | 표 캡션, 상단 중앙, 한/영 병기 |
| \biography{성명}{사진}{약력} | 채택 후 약력 (200자 이내, 규정 11) |

## 폰트
컨테이너에는 Noto Serif/Sans CJK KR로 설정. 출판사 폰트(HY견명조, HY중고딕,
신명조)가 있는 환경에서는 kiise.cls의 \setmainfont 부분만 교체하면 됨.

## BibTeX 지원 (kiise.bst)
인용 순서(unsrt) 기반으로 규정 8 형식을 구현:
- 저자 약자 표기: K. Park, H. Hwang, C. Lee, and S. Min
- 제목 따옴표, 콤마 내부: "Title,"
- 학술지: Journal(이탤릭), Vol. 34, No. 10, pp. 511-520, Oct. 2007. (in Korean)
- 단행본: 저자, 도서명(이탤릭), 발행소, 발행년도
- 월 약어 자동 (Oct., Mar. 등)

사용법:
```latex
\bibliographystyle{kiise}
\bibliography{references}
```
컴파일: xelatex main → bibtex main → xelatex main → xelatex main

국문 논문 표기는 .bib의 note 필드에 {(in Korean)} 추가.

## 머리글 (Running heads)
원본 양식 재현: 홀수면 = 논문 제목 + 쪽번호(오른쪽 위), 짝수면 = 쪽번호(왼쪽 위) + 학회지 권호 정보
```latex
\runningtitle{머리글용 논문 제목}
\journalinfo{정보과학회논문지: 정보통신 제 31 권 제 6 호(2004.12)}
```
twoside 조판이므로 PDF 뷰어에서 두 쪽 보기로 확인 가능.

## 1면 좌측단 각주 (사사, 저자 정보, 접수/심사일)
final 모드에서만 출력됨 (심사용은 규정 7-(1), 7-(4)에 따라 자동 미표기):
```latex
\firstpagefootnotes{%
  \fpitem{\dag}{이 논문은 ... 지원을 받아 수행된 연구임(No. ...)}
  \fpitem{\ddag}{정 회 원 : 소속\\ \mbox{}\quad email}
  \fpitem{\S}{정 회 원 : 소속\\ \mbox{}\quad 교신저자\\ \mbox{}\quad email}
  \fpitem{}{논문접수 : 2026. 6. 13}
  \fpitem{}{심사완료 : }
}
```

## 제목 크기
국문 제목 15.5pt / 영문 제목 11pt (원본 양식 기준)

## 하이퍼링크
hyperref 내장: \cite 번호(파란색) 클릭 시 참고문헌으로 이동.
그림/표/수식 \ref 링크도 활성화됨.
인쇄용으로 색을 빼려면 전문에 \hypersetup{hidelinks} 추가 (링크 기능은 유지).
