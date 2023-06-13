import * as React from "react"
import { HeadFC, Link, PageProps } from "gatsby"
import { top, display, circle, star as starStyle, plchldr1, threeCols, greyBorder } from "./old.module.scss"

import Button from "../components/button"

import logo from "../images/logo.svg"
import star from "../images/star.svg"

import logoMirri from "../images/logo-mirri.svg"
import logoPoo from "../images/logo-poo.png"
import logoSda from "../images/logo-sda.png"

const circles = Array.from({ length: 3 }, (_, i) => {
  const diameter = 40 + i * 40
  return (
    <div key={i} className={circle} style={{ width: `${diameter}rem`, height: `${diameter}rem` }} />
    )
})

interface Point {
  x: number;
  y: number;
}

function generateRandomPoints(maxCoordinates: number): Point[] {
  const maxAllowedCoordinates = maxCoordinates;

  const points: Point[] = [];

  for (let i = 0; i < maxAllowedCoordinates; i++) {
    let isValidPoint = false;
    let point: Point = { x: -1, y: -1 }; // Initialize with dummy values

    while (!isValidPoint) {
      point = {
        x: Math.random() * 100,
        y: Math.random() * 100
      };

      isValidPoint = points.every(p => calculateDistance(p, point) > 10);
    }

    points.push(point);
  }

  return points;
}

function calculateDistance(p1: Point, p2: Point): number {
  const dx = p1.x - p2.x;
  const dy = p1.y - p2.y;
  return Math.sqrt(dx * dx + dy * dy);
}

const maxCoordinates = 50;

const points = generateRandomPoints(maxCoordinates);

const stars = points.map((point, i) => {
  const size = 0.8 + Math.random() * 0.7
  return (
    <img key={i} src={star} alt="Star" className={starStyle} style={{ width: `${size}rem`, height: `${size}rem`, left: `${point.x}rem`, top: `${point.y}rem` }} />
  )
})

const IndexPage: React.FC<PageProps> = () => {
  return (
    <>
      <main>
        {stars}
        {circles}

        <div className={top}>
          <img src={logo} alt="Logo" />
          <div className={display}>
            <h1>Infomentor</h1>
            <p>Rozvíjame kritické myslenie a&nbsp;mediálnu gramotnosť v&nbsp;stredoškolskom prostredí.</p>
            <Button component="a" href="https://app.infomentor.sk" darkMode>
              Prejsť do aplikácie
            </Button>
          </div>
        </div>

        <section className={plchldr1}>
          <h2>Infomentor pomáha pri&nbsp;rozvoji mäkkých zručností</h2>
          <div>
            <div>
              <img src="https://placehold.co/300" />
              <h3>Problem-solving</h3>
              <p>V rámci Infomentora majú žiaci možnosť prechádzať týždennými výzvami, kde musia kriticky myslieť a hľadať efektívne riešenia. Pravidelným precvičovaním kritického myslenia môžu žiaci zlepšiť svoje schopnosti riešiť problémy, čo im <strong>umožní pristupovať k zložitým problémom sebavedome.</strong></p>
            </div>
            <div>
              <img src="https://placehold.co/300" />
              <h3>Komunikčné zručnosti</h3>
              <p>Kritické myslenie zahŕňa efektívne formulovanie myšlienok, nápadov a argumentov. Okrem týždenných výziev majú žiaci zapojiť sa do triedneho diskusného fóra, kde si môžu natrénovať argumentácie. Táto aktivita môže zlepšiť ich komunikačné schopnosti, vrátane schopnosti <strong>jasne vyjadrovať myšlienky, aktívne počúvať a vytvárať presvedčivé argumenty.</strong></p>
            </div>
            <div>
              <img src="https://placehold.co/300" />
              <h3>Decision-making</h3>
              <p>Robiť informované rozhodnutia je dôležitým aspektom kritického myslenia. Vďaka aplikácii Infomentor si žiaci môžu precvičiť vyhodnocovanie rôznych možností, zvažovanie potenciálnych dôsledkov a rozhodovanie sa pre správne možnosti na základe <strong>logických úvah a dôkazov.</strong></p>
            </div>
          </div>
        </section>

        <section className={threeCols}>
          <h2>Ako funguje appka Infomentor?</h2>
          <div>
            <div>
              <img src="https://placehold.co/100" />
              <h3>Týždenné výzvy</h3>
              <p>Pre žiakov sme pripravili testy, ktoré preskúšajú ich kritické myslenie na praktických príkladoch.</p>
            </div>
            <div>
              <img src="https://placehold.co/100" />
              <h3>Diskusné fórum</h3>
              <p>Učitelia majú možnosť v rámci triedy založiť diskusiu na aktuálne dianie, kde sa žiaci môžu vyjadriť a precvičiť si tak svoje argumentačné schopnosti.</p>
            </div>
            <div>
              <img src="https://placehold.co/100" />
              <h3>Vzdelávanie</h3>
              <p>Učitelia aj žiaci tu môžu nájsť tipy na vzdelávacie podujatia, projekty a materiály, ktoré ich môžu posunúť ďalej.</p>
            </div>
          </div>
        </section>

        <section>
          <blockquote>
            {stars}
            {circles}
            <div>
              <img src="https://placehold.co/200" />
              <p>Marianna Szarková</p>
            </div>
            <p>Z dlhodobého hľadiska patrí Slovensko pod priemer v krajinách OECD v prieskumoch PISA. Aj z tohto dôvodu sme vyvinuli Infomentor – aplikáciu ktorá interaktívnou a zábavnou formou sprevádza stredoškolských študentov pri rozvoji kritického myslenia a mediálnej gramotnosti. Výučba kritického myslenia sa teda vďaka našej aplikácii nemusí vykonávať prostredníctvom nových učebníc, ale jednoducho cez týždenné výzvy zamerané na jednotlivé aspekty mediálnej gramotnosti, ktoré boli pripravené v spolupráci so Slovenskou debatnou asociáciou.</p>
          </blockquote>
        </section>

        <section className={greyBorder}>
          <div>
            <h2>Ako sa zapojiť?</h2>
            <p>Obsah týždenných výziev a diskusií je navrhnutý tak, aby sa dal jednoducho implementovať do osnov predmetov ako sú Slovenský jazyk, Dejepis, Etika alebo Občianska náuka. Počas tvorby otázok sme dbali na to, aby sme sa držali v medziach štátneho vzdelávacieho programu.</p>
            <p>Ak si ako stredná škola prajete Infomentor implementovať do výučbového procesu, <a href="mailto:08majka80@gmail.com">kontaktujte nás</a>.</p>
          </div>
        </section>
      </main>

      <footer>
        {stars}
        {circles}
        <p>
          &copy; {new Date().getFullYear()} Infomentor.sk All rights reserved.
        </p>
        <div>
            <img src={logoMirri} alt="Logo Ministerstva investícií, regionálneho rozvoja a informatizácie SR" />
            <img src={logoPoo} alt="Logo Plánu obnovy" />
            <img src={logoSda} alt="Logo Slovenskej debatnej asociácie" />
        </div>
      </footer>
    </>
  )
}

export default IndexPage

export const Head: HeadFC = () => <title>Infomentor</title>
