import * as React from "react"
import { HeadFC, PageProps } from "gatsby"
import "./index.module.scss"

import images from "../images"

const year = new Date().getFullYear()

const IndexPage: React.FC<PageProps> = () => {
  return (
    <>
      <main>
        <header>
          <nav><img src={images.logo} alt="Infomentor logo" /></nav>
          <div>
            <div className="text">
              <h1>Infomentor</h1>
              <p>Rozvíjame kritické myslenie a&nbsp;mediálnu gramotnosť v&nbsp;stredoškolskom prostredí.</p>
              <a data-type="button" href="https://app.infomentor.sk">Prejsť do&nbsp;aplikácie</a>
            </div>
            <div className="image">
              <img src={images.sample} alt="App sample" />
            </div>
            <div className="circle" style={{ left: "-75rem", top: "-10rem", }}></div>
            <div className="circle" data-hideOnMobile style={{ right: "-40rem", top: "-65rem", }}></div>
          </div>
        </header>

        <section className="columns">
          <h2>Infomentor pomáha pri rozvoji mäkkých zručností</h2>
          <div>
            <div>
              <img src={images.problemSolving} alt="" />
              <h3>Problem-solving</h3>
              <p>V&nbsp;rámci Infomentora majú žiaci možnosť prechádzať týždennými výzvami, kde musia kriticky myslieť a&nbsp;hľadať efektívne riešenia. Pravidelným precvičovaním kritického myslenia môžu žiaci zlepšiť svoje schopnosti riešiť problémy, čo im <strong>umožní pristupovať k&nbsp;zložitým problémom sebavedome.</strong></p>
            </div>
            <div>
              <img src={images.communication} alt="" />
              <h3>Komunikačné zručnosti</h3>
              <p>Kritické myslenie zahŕňa efektívne formulovanie myšlienok, nápadov a&nbsp;argumentov. Okrem týždenných výziev majú žiaci zapojiť sa do&nbsp;triedneho diskusného fóra, kde si môžu natrénovať argumentácie. Táto aktivita môže zlepšiť ich komunikačné schopnosti, vrátane schopnosti <strong>jasne vyjadrovať myšlienky, aktívne počúvať a&nbsp;vytvárať presvedčivé argumenty.</strong></p>
            </div>
            <div>
              <img src={images.decisionMaking} alt="" />
              <h3>Decision-making</h3>
              <p>Robiť informované rozhodnutia je dôležitým aspektom kritického myslenia. Vďaka aplikácii Infomentor si žiaci môžu precvičiť vyhodnocovanie rôznych možností, zvažovanie potenciálnych dôsledkov a&nbsp;rozhodovanie sa pre&nbsp;správne možnosti na&nbsp;základe <strong>logických úvah a&nbsp;dôkazov.</strong></p>
            </div>
          </div>
        </section>

        <section className="rows">
          <div>
            <h2>Ako appka funguje?</h2>
            <div>
              <div>
                <img src={images.forum} alt="Diskusné fórum" />
                <img className="icon" src={images.forumIcon} alt="Diskusné fórum" />
                <div>
                  <h3>Diskusné fórum</h3>
                  <p>Učitelia majú možnosť v rámci triedy založiť diskusiu na aktuálne dianie, kde sa žiaci môžu vyjadriť a precvičiť si tak svoje argumentačné schopnosti.</p>
                </div>
              </div>
              <div>
                <img src={images.challenges} alt="Týždenné výzvy" />
                <img className="icon" src={images.challengesIcon} alt="Týždenné výzvy" />
                <div>
                  <h3>Týždenné výzvy</h3>
                  <p>Pre žiakov sme pripravili testy, ktoré preskúšajú ich kritické myslenie na praktických príkladoch.</p>
                </div>
              </div>
              <div>
                <img src={images.education} alt="Vzdelávanie" />
                <img className="icon" src={images.educationIcon} alt="Vzdelávanie" />
                <div>
                  <h3>Vzdelávanie</h3>
                  <p>Učitelia aj žiaci tu môžu nájsť tipy na vzdelávacie podujatia, projekty a materiály, ktoré ich môžu posunúť ďalej.</p>
                </div>
              </div>
            </div>
          </div>
          <div className="image">
            <img src={images.howItWorks} alt="Ako appka funguje?" />
          </div>
          <div className="circle" data-hideOnDesktop style={{ right: "-75rem", top: "-5rem", }}></div>
          <div className="circle" data-hideOnMobile style={{ right: "-30rem", top: "-15rem", }}></div>
        </section>

        <section className="text">
          <h2>Ako sa zapojiť?</h2>
          <p>Obsah týždenných výziev a diskusií je navrhnutý tak, aby sa dal jednoducho implementovať do osnov predmetov ako sú Slovenský jazyk, Dejepis, Etika alebo Občianska náuka. Počas tvorby otázok sme dbali na to, aby sme sa držali v medziach štátneho vzdelávacieho programu. Ak si ako stredná škola prajete Infomentor implementovať do výučbového procesu, kontaktujte nás.</p>
          <a data-type="button" className="secondary" href="mailto:08majka80@gmail.com">Kontaktujte nás</a>
        </section>
        
        <section className="quote">
          <img className="hideOnMobile" src={images.mariannaSzarkova} alt="Marianna Szarková" />
          <div>
            <h2>Prečo sa zapojiť?</h2>
            <img src={images.mariannaSzarkova} alt="Marianna Szarková" />
            <div>
              <p>„Z dlhodobého hľadiska patrí Slovensko pod priemer v krajinách OECD v prieskumoch PISA. Aj z tohto dôvodu sme vyvinuli Infomentor – aplikáciu ktorá interaktívnou a zábavnou formou sprevádza stredoškolských študentov pri rozvojikritického myslenia a mediálnej gramotnosti. Výučba kritického myslenia sa teda vďaka našej aplikácii nemusí vykonávať prostredníctvom nových učebníc, ale jednoducho cez týždenné výzvy zamerané na jednotlivé aspekty mediálnej gramotnosti, ktoré boli pripravené v spolupráci so Slovenskou debatnou asociáciou.“</p>
              <p className="name">- Marianna Szarková</p>
            </div>
          </div>
        </section>

        <footer>
          <div className="logo">
            <img src={images.logo} alt="Infomentor logo" />
            <p>&copy; {year}</p>
          </div>
          <ul>
            <p>Linky</p>
            <li>Žiacke rozhranie</li>
            <li>Učiteľské rozhranie</li>
            <li>Administrátorské rozhranie</li>
            <li><a href="https://dev.infomentor.sk">Testovacie rozhranie</a></li>
            <li>Registrácia školy</li>
            <li><a href="mailto:08majka80@gmail.com">Kontakt</a></li>
          </ul>
          <div>
            <p>S podporou</p>
            <div className="images">
              <a href="https://www.mirri.gov.sk/" target="_blank"><img src={images.logoMirri} alt="Logo MIRRI" /></a>
              <a href="https://www.planobnovy.sk/" target="_blank"><img src={images.logoPOO} alt="Logo Plán obnovy" /></a>
              <a href="https://www.sda.sk/" target="_blank"><img src={images.logoSDA} alt="Logo SDA" /></a>
            </div>
          </div>
        </footer>
      </main>
    </>
  )
}

export default IndexPage

export const Head: HeadFC = () => <title>Infomentor</title>
