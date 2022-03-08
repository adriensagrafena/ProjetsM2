\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{compterendu}[2019/08/28 v0.1 Standard LaTeX document class]
\LoadClass[a4paper, 11pt]{article}
\newcommand{\logouniv}[1]{\def\@logouniv{#1}}
\newcommand{\logoufr}[1]{\def\@logoufr{#1}}
\newcommand{\anac}[1]{\def\@anac{#1}}
\newcommand{\theanac}{\@anac}
\newcommand{\diplome}[1]{\def\@diplome{#1}}
\newcommand{\thediplome}{\@diplome}
\newcommand{\module}[1]{\def\@module{#1}}
\newcommand{\themodule}{\@module}
\newcommand{\enseig}[1]{\def\@enseig{#1}}
\newcommand{\theenseig}{\@enseig}
\newcommand{\evaluation}[1]{\def\@evaluation{#1}}
\newcommand{\theeval}{\@evaluation}
\newcommand{\email}[1]{\def\@email{#1}}
\newcommand{\theauthor}{\@author}
\newcommand{\thetitle}{\@title}
\logouniv{}
\logoufr{}
\anac{}
\diplome{}
\module{}
\enseig{}
\evaluation{}
\email{}

\RequirePackage{graphicx}
\RequirePackage[table]{xcolor}
\RequirePackage{hyperref}

\definecolor{urcalightbrown}{RGB}{172,114, 50}
\definecolor{urcabrown}{RGB}{75,0, 0}

\renewcommand{\maketitle}{
 \thispagestyle{plain}
 \noindent
  \begin{minipage}{\textwidth}
    \begin{tabular}{@{}c@{}}
      \includegraphics[width=3cm]{\@logouniv}
    \end{tabular}%
    \hfill%
    \begin{tabular}{@{}c@{}}
      {Ann\'ee universitaire \@anac} \\
      {\@diplome}\\ 
      {\@module \ (resp. : \@enseig)} \\  \\
      {\bf \large \@evaluation}
   \end{tabular}
    \hfill
    \begin{tabular}{@{}c@{}}
      \\%
      \includegraphics[width=2.6cm]{\@logoufr}
    \end{tabular}
  \end{minipage}
\par
\noindent
\hrulefill

  \vskip 20\p@
  \noindent
  \begin{center}%
    {\LARGE \bf \textcolor{urcabrown}{ \@title} \par}%
    \vskip 3em%
    {\large
     \lineskip .75em%
      % \begin{tabular}[t]{c}%
      %   \@author % \ -- \texttt{\@email}
      % \end{tabular}\par}%
       \begin{tabular}[t]{cc}
        \begin{minipage}{0.45\textwidth}
         \flushright
         \@author
        \end{minipage}
        &
       \begin{minipage}{0.45\textwidth}
         \flushleft
         \@email
        \end{minipage}
       \end{tabular}\par}
      \vskip 20\p@%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \vskip 20\p@  
  
  \noindent
  \begin{tabular}{|@{}p{\textwidth}@{}|}
  \hline
  \hspace{\parindent}
  { \small Appr\'eciations et note du correcteur :} \\
  
  \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \\ \hline
  \end{tabular}
  
%  \global\let\thanks\relax
%  \global\let\maketitle\relax
%  \global\let\@maketitle\relax
%  \global\let\@thanks\@empty
%  \global\let\@author\@empty
%  \global\let\@date\@empty
%  \global\let\@title\@empty
%  \global\let\title\relax
%  \global\let\author\relax
%  \global\let\date\relax
%  \global\let\and\relax
}

