%% kiise.cls --- KIISE 논문지 양식 LaTeX class (XeLaTeX 전용)
%% ex_paper01.hwp / ex_paper02.doc 양식 기반 재현
%% 판형 188 x 258 mm, 2단 조판
%%
%% 사용법:  \documentclass{kiise}            % 심사용 (저자 정보 미표기, blind)
%%          \documentclass[final]{kiise}     % 채택 후 (저자 표기)
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kiise}[2026/06/13 v1.6 KIISE journal style (paired per-author names, titles 15.5/11pt, first-page footnotes, centered headers, hyperref)]

\newif\if@kiisefinal\@kiisefinalfalse
\DeclareOption{final}{\@kiisefinaltrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[twocolumn,twoside,9pt]{extarticle}

%% ---------- 판형 및 여백 (원본 doc sectPr 측정값) ----------
\RequirePackage{geometry}
\geometry{
  paperwidth=188mm, paperheight=258mm,
  left=21mm, right=21mm,
  top=38mm, bottom=18mm,
  headheight=5mm, headsep=8mm,
  footskip=8mm,
  columnsep=6mm,
}

%% ---------- 한글 / 폰트 (엔진 자동 감지) ----------
\RequirePackage{iftex}
\ifPDFTeX
  %% pdfLaTeX: kotex (레거시 호환 모드, Type1 폰트)
  \RequirePackage[utf]{kotex}
  \RequirePackage[T1]{fontenc}
\else
  %% LuaLaTeX / XeLaTeX: fontspec + OpenType 폰트 (권장)
  \RequirePackage{fontspec}
  % 시스템에 HY견명조/HY중고딕/신명조가 있으면 교체 권장
  \IfFontExistsTF{Noto Serif CJK KR}{%
    \setmainfont{Noto Serif CJK KR}[BoldFont={* Bold}]%
    \setsansfont{Noto Sans CJK KR}[BoldFont={* Bold}]%
  }{%
    \IfFontExistsTF{NanumMyeongjo}{%
      \setmainfont{NanumMyeongjo}\setsansfont{NanumGothic}%
    }{\ClassWarning{kiise}{No Korean font found; install Noto CJK KR or Nanum fonts}}%
  }
  \ifLuaTeX
    %% LuaLaTeX: luatexko가 있으면 사용 (한글 조판 최적)
    \IfFileExists{luatexko.sty}{\RequirePackage{luatexko}}{}
  \else
    %% XeLaTeX: 한글 줄바꿈 허용
    \XeTeXlinebreaklocale "ko"
    \XeTeXlinebreakskip = 0pt plus 0.5pt minus 0.1pt
  \fi
\fi

%% ---------- 기본 패키지 ----------
\RequirePackage{amsmath,amssymb,graphicx,array,booktabs}
\RequirePackage{titlesec}
\RequirePackage{caption}
\RequirePackage{etoolbox}

%% ---------- 하이퍼링크 (인용 번호 클릭 시 참고문헌으로 이동) ----------
\RequirePackage[colorlinks=true,
                citecolor=blue,    % 인용 번호 색
                linkcolor=black,   % 그림/표/수식 내부 링크
                urlcolor=blue]{hyperref}
%% 인쇄용으로 색 없이 링크만 유지하려면 위 옵션 대신: \hypersetup{hidelinks}

\setlength{\parindent}{1em}
\linespread{1.05}

%% ---------- 머리글/바닥글 (원본 양식: 짝수=좌측 쪽번호+학회지 정보, 홀수=논문제목+우측 쪽번호) ----------
\RequirePackage{fancyhdr}
\newcommand{\journalinfo}[1]{\def\@journalinfo{#1}}   % 학회지명, 권호 (짝수면 머리글)
\newcommand{\runningtitle}[1]{\def\@runningtitle{#1}} % 머리글용 짧은 제목 (홀수면)
\def\@journalinfo{정보과학회논문지}
\def\@runningtitle{}
\fancyhf{}
\fancyhead[LE]{\fontsize{8pt}{10pt}\selectfont \thepage}
\fancyhead[CE]{\fontsize{8pt}{10pt}\selectfont \@journalinfo}
\fancyhead[CO]{\fontsize{8pt}{10pt}\selectfont \@runningtitle}
\fancyhead[RO]{\fontsize{8pt}{10pt}\selectfont \thepage}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}

%% ---------- 메타데이터 명령 ----------
\newcommand{\koreantitle}[1]{\def\@koreantitle{#1}}
\newcommand{\englishtitle}[1]{\def\@englishtitle{#1}}
\newcommand{\koreanauthors}[1]{\def\@koreanauthors{#1}}   % final 옵션에서만 출력
\newcommand{\englishauthors}[1]{\def\@englishauthors{#1}} % final 옵션에서만 출력
\def\@koreanauthors{}\def\@englishauthors{}

%% 저자 단위 입력: \addauthor{홍 길 동}{Gil Dong Hong}
%% 여러 명은 \addauthor를 반복 호출. 국문 이름 아래에 영문 이름이 괄호로 각각 묶여 정렬됨.
\newcounter{kiise@nauthors}
\long\def\@authorblock{}
\newcommand{\addauthor}[2]{%
  \stepcounter{kiise@nauthors}%
  \ifnum\value{kiise@nauthors}=1
    \g@addto@macro\@authorblock{\kiise@oneauthor{#1}{#2}}%
  \else
    \g@addto@macro\@authorblock{\hspace{2.5em}\kiise@oneauthor{#1}{#2}}%
  \fi}
\newcommand{\kiise@oneauthor}[2]{%
  \begin{tabular}[t]{@{}c@{}}
    {\fontsize{10pt}{13pt}\selectfont\sffamily #1}\\[2pt]
    {\fontsize{9pt}{12pt}\selectfont (#2)}
  \end{tabular}}

\long\def\@koreanabstract{}\long\def\@englishabstract{}
\newcommand{\koreanabstract}[1]{\long\def\@koreanabstract{#1}}   % 300~500자
\newcommand{\englishabstract}[1]{\long\def\@englishabstract{#1}} % 100~200단어
\newcommand{\koreankeywords}[1]{\def\@koreankeywords{#1}}        % 4~6개
\newcommand{\englishkeywords}[1]{\def\@englishkeywords{#1}}      % 4~6개

%% ---------- 표제부 (국문제목, 영문제목, 국문요약/키워드, 영문요약/키워드) ----------
%% ---------- 1면 좌측단 각주 (사사, 저자 정보, 접수/심사일 — final 모드 전용) ----------
%% \firstpagefootnotes{
%%   \fpitem{\dag}{이 논문은 ... 지원을 받아 수행된 연구임(No. ...)}
%%   \fpitem{\ddag}{정 회 원 : 국립한밭대학교 컴퓨터공학과\\ parkce@hanbat.ac.kr}
%%   \fpitem{\S}{정 회 원 : 한국전자통신연구원(ETRI)\\ 교신저자\\ h.kim@etri.re.kr}
%%   \fpitem{}{논문접수 : }
%%   \fpitem{}{심사완료 : }
%% }
\long\def\@fpfn{}
\newcommand{\firstpagefootnotes}[1]{\long\def\@fpfn{#1}}
\newcommand{\fpitem}[2]{%
  \par\noindent\hangindent=1.2em\hangafter=1
  \hbox to 1.2em{#1\hfil}#2\par}

\renewcommand{\maketitle}{%
  \twocolumn[%
    \begin{center}
      {\fontsize{15.5pt}{19.5pt}\selectfont\bfseries \@koreantitle\par}
      \vskip 4pt
      {\fontsize{11pt}{14pt}\selectfont (\@englishtitle)\par}
      \if@kiisefinal
        \vskip 10pt
        \ifnum\value{kiise@nauthors}>0
          {\@authorblock\par}%
        \else
          {\fontsize{10pt}{14pt}\selectfont\sffamily \@koreanauthors\par}%
          \vskip 2pt
          {\fontsize{9pt}{12pt}\selectfont (\@englishauthors)\par}%
        \fi
      \fi
      \vskip 14pt
    \end{center}
    \begingroup
      \fontsize{9pt}{13pt}\selectfont
      \noindent{\bfseries 요\hskip 1em 약}\hskip 1em \@koreanabstract\par
      \vskip 6pt
      \noindent{\bfseries 키워드} : \@koreankeywords\par
      \vskip 10pt
      \noindent{\bfseries Abstract}\hskip 1em \@englishabstract\par
      \vskip 6pt
      \noindent{\bfseries Key words} : \@englishkeywords\par
    \endgroup
    \vskip 18pt
  ]%
  %% 1면 좌측단 하단 각주 (final 모드에서만)
  \if@kiisefinal
    \ifdefempty{\@fpfn}{}{%
      \begingroup
        \renewcommand{\thefootnote}{}%
        \interfootnotelinepenalty=\@M
        \footnotetext{\fontsize{8pt}{10pt}\selectfont\@fpfn}%
      \endgroup}%
  \fi
}

%% ---------- 장/절 번호: 1., 1.1 (규정 9) ----------
\titleformat{\section}
  {\fontsize{10pt}{13pt}\selectfont\sffamily\bfseries}
  {\thesection.}{0.6em}{}
\titlespacing*{\section}{0pt}{12pt plus 2pt}{6pt}

\titleformat{\subsection}
  {\fontsize{9pt}{12pt}\selectfont\sffamily\bfseries}
  {\thesubsection}{0.6em}{}
\titlespacing*{\subsection}{0pt}{10pt plus 2pt}{4pt}

\titleformat{\subsubsection}
  {\fontsize{9pt}{12pt}\selectfont\bfseries}
  {\thesubsubsection}{0.6em}{}
\titlespacing*{\subsubsection}{0pt}{8pt plus 2pt}{4pt}

%% ---------- 그림/표 캡션: 국문 + 영문 병기 (규정 10) ----------
%% 그림: 하단 중앙 / 표: 상단 중앙
%% \figcaption{국문 제목}{English title}
%% \tabcaption{국문 제목}{English title}
\newcounter{kfigure}\newcounter{ktable}
\renewcommand{\thekfigure}{\arabic{kfigure}}
\renewcommand{\thektable}{\arabic{ktable}}

\newcommand{\figcaption}[2]{%
  \refstepcounter{kfigure}%
  \begin{center}\vskip 4pt
    {\fontsize{8pt}{11pt}\selectfont 그림~\thekfigure\hskip 0.7em #1\\
     Fig.~\thekfigure\hskip 0.7em #2}%
  \end{center}}

\newcommand{\tabcaption}[2]{%
  \refstepcounter{ktable}%
  \begin{center}
    {\fontsize{8pt}{11pt}\selectfont 표~\thektable\hskip 0.7em #1\\
     Table~\thektable\hskip 0.7em #2}%
    \vskip 4pt
  \end{center}}

%% ---------- 참고문헌 (영문 표기, 인용 순서, [n]) ----------
\renewcommand{\refname}{참\hskip 0.5em 고\hskip 0.5em 문\hskip 0.5em 헌}
\AtBeginEnvironment{thebibliography}{\fontsize{8pt}{11pt}\selectfont}
\renewenvironment{thebibliography}[1]{%
  \par\vskip 12pt
  {\centering\sffamily\bfseries\fontsize{10pt}{13pt}\selectfont \refname\par}
  \vskip 6pt
  \fontsize{8pt}{11pt}\selectfont
  \list{\@biblabel{\@arabic\c@enumiv}}%
       {\settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth \advance\leftmargin\labelsep
        \itemsep 1pt \parsep 0pt
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}}%
  \sloppy\clubpenalty4000\widowpenalty4000%
  \sfcode`\.\@m}
 {\def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
  \endlist}

%% ---------- 저자 약력 (채택 후, final 옵션) ----------
%% \biography{성명}{사진파일(생략 가능 시 공백)}{약력 200자 이내}
\newcommand{\biography}[3]{%
  \if@kiisefinal
  \par\vskip 8pt
  \noindent\begin{minipage}[t]{0.27\columnwidth}
    \ifblank{#2}{\fbox{\rule{0pt}{2.4cm}\rule{1.8cm}{0pt}}}{\includegraphics[width=\linewidth]{#2}}
  \end{minipage}\hfill
  \begin{minipage}[t]{0.69\columnwidth}
    {\fontsize{9pt}{12pt}\selectfont\sffamily\bfseries #1}\par\vskip 2pt
    {\fontsize{8pt}{11pt}\selectfont #3\par}
  \end{minipage}\par
  \fi}

\endinput
