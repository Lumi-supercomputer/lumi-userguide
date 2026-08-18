# LUMI AI Factory Dataset as a Service dataset guides
[data catalogue]: https://lumi-aif.fairdata.fi
[weather observations]: https://lumi-aif.fairdata.fi/dataset/371bcf2e-f2f0-40e7-8c70-b3a87d843b36/
[weather observations lumi-o]: https://462001541.lumidata.eu/obs-ai-parquet-data/

This page details additional information of datasets in the LUMI AI Factory Dataset as a Service catalog (LUMI AIF DaaS). This can be for example data management guidelines, variable description or other relevant documentation about the compiling, structuring and upkeep of the dataset. 

This page only has information that is not already stored elsewhere. Your main source of information about the datasets is the LUMI AIF DaaS [data catalogue].

## Weather observations (2001-2025) for AI training
You can find the general information of [Weather observations (2001-2025) for AI training in it's data catalogue entry][weather observations]. These variable descriptions help you understand the [data accessibly in LUMI][weather observations LUMI-O].
### Mesurands of Finnish observations
| MEASURAND_ID | MEASURAND_CODE | MEASURAND_NAME | MEASURAND_LONG_NAME | MEASURAND_UNIT |
| --- | --- | --- | --- | --- |
| 1 | TA_PT1M_AVG | Ilman lämpötila | Ilman lämpötila, hetkellinen | degC |
| 2 | TS_PT1M_AVG | Maalämpötila | Maalämpötila, hetkellinen | degC |
| 3 | TW_PT1M_AVG | Veden lämpötila | Veden lämpötila, hetkellinen | degC |
| 23 | TG_PT12H_MIN | Maanpintaminimi | Alin lämpötila lähellä maanpintaa, 12 tuntia | degC |
| 29 | RH_PT1M_AVG | Suhteellinen kosteus | Suhteellinen kosteus, hetkellinen | % |
| 32 | TD_PT1M_AVG | Kastepistelämpötila | Kastepistelämpötila, hetkellinen | degC |
| 37 | PA_PT1M_AVG | Ilmanpaine (msl) | Ilmanpaine, merenpintaan redukoitu, hetkellinen | hPa |
| 41 | WS_PT10M_AVG | Tuulen nopeus | Tuulen nopeus, 10 minuutin keskiarvo | m/s |
| 42 | WS_PT2M_AVG | Tuulen nopeus | Tuulen nopeus, 2 minuutin keskiarvo | m/s |
| 44 | WD_PT10M_AVG | Tuulen suunta | Tuulen suunta, 10 minuutin keskiarvo | deg |
| 45 | WD_PT2M_AVG | Tuulen suunta | Tuulen suunta, 2 minuutin keskiarvo | deg |
| 47 | WG_PT10M_MAX | Puuskanopeus | Puuskanopeus | m/s |
| 53 | WS_PT3H_MAX | Suurin tuulen nopeus | Tuulen nopeus, maksimi, 3 tuntia | m/s |
| 54 | VIS_PT1M_AVG | Näkyvyys | Meteorologinen näkyvyys | m |
| 56 | WAWA_PT1M_RANK | Vallitseva sää (auto) | Vallitseva sään koodi, automaattinen |  |
| 67 | PRI_PT10M_AVG | Sateen intensiteetti | Sateen intensiteetti, keskiarvo, 10 minuuttia | mm/h |
| 69 | PRON_PT10M_ACC | Sadetta kyllä/ei | Sadetta kyllä/ei,hetkellinen |  |
| 84 | SND_PT1M_INSTANT | Lumensyvyys | Lumensyvyys | cm |
| 119 | CLA_PT1M_ACC | Pilvien määrä | Pilvien määrä | 1/8 |
| 120 | CLHB_PT1M_INSTANT | Pilven alarajan korkeus | Alimpien pilvien alarajan pilvenkorkeus | m |
| 128 | ICEST_PT10M_AVG | Jäätäminen | Jään kertyminen pinnalle, tilatieto |  |
| 129 | WSP_PT10M_AVG | Potentiaalituuli | Tuulen potentiaalinopeus, 10 minuutia | m/s |
| 173 | PRIO_PT10M_AVG | Sateen intensiteetti (optinen) | Sateen intensiteetti optiselta anturilta, keskiarvo, 10 minuuttia | mm/h |
| 270 | TG_PT1M_AVG | Maanpintalämpötila | Maanpintalämpötila (lähellä maanpintaa), hetkellinen | degC |
| 573 | WSC_PT10M_AVG | Tuulen nopeus,jatkuva | Tuulen nopeus, 10 minuutin keskiarvo,jatkuva | m/s |
| 574 | WDC_PT10M_AVG | Tuulen suunta,jatkuva | Tuulen suunta, 10 minuutin keskiarvo,jatkuva | deg |
| 622 | PRA_PT10M_MAX | Sademäärän maksimi | Edeltävän jakson suurin 1 min sademäärä | mm |
| 623 | PRAO_PT10M_MAX | Optisen sademäärän maksimi | Edeltävän jakson suurin 1 min optinen sademäärä | mm |
| 681 | WSD_PT10M_AVG | Tuulen nopeus, epäjatkuva | Tuulen nopeus, 10 minuutin keskiarvo, epäjatkuva | m/s |
| 682 | WDD_PT10M_AVG | Tuulen suunta, epäjatkuva | Tuulen suunta, 10 minuutin keskiarvo, epäjatkuva | deg |
| 683 | WGD_PT10M_MAX | Puuskanopeus, epäjatkuva | Puuskanopeus , epäjatkuva | m/s |

### Mesurands of global observations
| MEASURAND_ID | MEASURAND_CODE | MEASURAND_NAME | UNIT_SYMBOL |
| --- | --- | --- | --- |
| 286 | TA | Air temperature (TTT) | °C |
| 287 | TAMAX1H | Maximum air temperature past one hour | °C |
| 288 | TAMIN1H | Minimum air temperature past one hour | °C |
| 449 | CNH | Cloud amount, of low or middle clouds (Nh) | code |
| 450 | CTCL | Cloud type, low clouds (CL) | code |
| 451 | CTCM | Cloud type, medium clouds (CM) | code |
| 452 | CTCH | Cloud type, high clouds (CH) | code |
| 453 | CN | Cloud amount, total (N) | code |
| 454 | CH | Height of base of cloud (h) | m |
| 463 | CNL3 | Amount of cloud, third lowest cloud layer (Ns) | octa |
| 464 | CHL1 | Height of base of cloud, lowest cloud layer (hshs) | m |
| 465 | CTL1 | Type of cloud, lowest cloud layer (C) | code |
| 466 | CNL2 | Amount of cloud, second lowest cloud layer (Ns) | octa |
| 467 | CHL2 | Height of base of cloud, second lowest cloud layer (hshs) | m |
| 468 | CTL2 | Type of cloud, second lowest cloud layer (C) | code |
| 469 | WG1H | Maximum gust speed past 1 hour | m/s |
| 470 | CHL3 | Height of base of cloud, third lowest cloud layer (hshs) | m |
| 471 | CTL3 | Type of cloud, third lowest cloud layer (C) | code |
| 472 | CNL4 | Amount of cloud, fourth lowest cloud layer (Ns) | octa |
| 473 | CHL4 | Height of base of cloud, fourth lowest cloud layer (hshs) | m |
| 474 | CTL4 | Type of cloud, fourth lowest cloud layer (C) | code |
| 475 | WD | Wind direction (dd) | ° |
| 476 | WS | Wind speed (ff) | m/s |
| 477 | WG | Wind gust speed (fxfx) | m/s |
| 478 | TAMAX12H | Maximum air temperature past 12 hours (TxTxTx) | °C |
| 479 | TAMIN12H | Minimum air temperature past 12 hours (TnTnTn) | °C |
| 480 | TD | Dew-point temperature (TdTdTd) | °C |
| 481 | TG | Ground minimum temperature, past 12 hours (TgTg) | °C |
| 482 | RH | Relative humidity () | % |
| 483 | PR_24H | Precipitation past 24 hours (RRR) | mm |
| 484 | PR_12H | Precipitation past 12 hours (RRR) | mm |
| 485 | PR_6H | Precipitation past 6 hours (RRR) | mm |
| 486 | PR_1H | Precipitation past 1 hour (RRR) | mm |
| 487 | SD | Snow depth (sss) | cm |
| 488 | E | State of ground with or without snow (E or E') | code |
| 489 | VV | Horizontal visibility (VV) | m |
| 490 | W1 | Past weather (1) (W1) | code |
| 491 | W2 | Past weather (2) (W2) | code |
| 492 | WW | Present weather (ww) | code |
| 493 | PPP | Pressure change, 3 hours (ppp) | hPa |
| 494 | P0 | Pressure at station level (P0P0P0P0) | hPa |
| 495 | PSEA | Pressure reduced to mean sea level (PPPP) | hPa |
| 496 | Pa | Characteristic of pressure tendency (a) | code |
| 501 | TAMAX24H | Maximum air temperature past 24 hours | °C |
| 502 | TAMIN24H | Minimum air temperature past 24 hours | °C |
| 503 | NET | Net radiation, integrated over 24 hours | J/m2 |
| 521 | SUNDUR | Total sunshine over 24 hours | min |
| 522 | GPM | Geopontential height | m |
