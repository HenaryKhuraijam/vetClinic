
SELECT * from animals WHERE name LIKE '%mon';
SELECT name from animals WHERE date_of_birth BETWEEN '2016-1-1' AND '2019-12-31';
SELECT * from animals WHERE neutered IS TRUE AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name IN ('Agumon','Pikachu');
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered IS TRUE;
SELECT * from animals WHERE name != 'Gabumon';
SELECT * from animals WHERE weight_kg >= 10.5 AND weight_kg <= 17.3;

/* Update */

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name like '%mon%';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-1-1';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(name) from animals;
SELECT COUNT(name) from animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) from animals;
SELECT neutered, MAX(escape_attempts) from animals GROUP BY neutered;
SELECT species, MAX(weight_kg), MIN(weight_kg) from animals GROUP BY species;
SELECT species, AVG(escape_attempts) from animals WHERE date_of_birth BETWEEN '1990-1-1' AND '2000-12-31' GROUP BY species;


/* queries using JOIN */
/* animals belong to Melody Pond */
SELECT name, full_name FROM animals
INNER JOIN owners ON animals.owners_id = owners.id
WHERE owners.full_name = 'Melody Pond';

/* all animals that are pokemon */
SELECT animals.name, species.name FROM animals
INNER JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

/* Number animals are there per species */
SELECT species.name, COUNT(*) FROM animals
FULL JOIN species ON animals.species_id = species.id
GROUP BY species.name;

/* all owners and their animals, including those who don't own any animal */
SELECT full_name, name FROM animals RIGHT JOIN owners ON animals.owners_id = owners.id;

/* Digimon owned by Jennifer Orwell. */
SELECT species.name, animals.name, owners.full_name FROM animals
INNER JOIN species ON animals.species_id = species.id
INNER JOIN owners ON animals.owners_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

/* all animals owned by Dean Winchester that haven't tried to escape. */
SELECT animals.name, animals.escape_attempts FROM animals
INNER JOIN owners ON animals.owners_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

/* owns the most animals */
SELECT owners.full_name, COUNT(animals.name) FROM animals
JOIN owners ON animals.owners_id = owners.id
GROUP BY owners.full_name ORDER BY count DESC LIMIT 1;

/* JoinTable*/
/* last animal seen by William Tatcher */

SELECT vets.name as "Vet's Name", visits.date_of_visit as "Last Visit", animals.name as "Name of Animal"
FROM vets INNER JOIN visits ON vets.id = visits.vets_id
LEFT JOIN animals ON animals.id = visits.animals_id
WHERE vets.name = 'William Tatcher' ORDER BY date_of_visit DESC LIMIT 1;

/* different animals that Stephanie Mendez saw */

SELECT COUNT(animals.name) FROM vets JOIN visits ON vets.id = visits.vets_id
JOIN animals ON animals.id = visits.animals_id WHERE vets.name = 'Stephanie Mendez';

/* List all vets and their specialties, including vets with no specialties */
SELECT vets.name as vet, species.name as specialization FROM vets FULL JOIN specializations ON vets.id = specializations.vets_id
LEFT JOIN species ON species.id = specializations.species_id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020 */
SELECT animals.name, visits.date_of_visit FROM animals JOIN visits ON animals.id = visits.animals_id
RIGHT JOIN vets ON vets.id = visits.vets_id WHERE vets.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT animals.name, COUNT(*) as visited FROM animals INNER JOIN visits ON animals.id = visits.animals_id
GROUP BY animals.name ORDER BY visited DESC LIMIT 1;

/* Who was Maisy Smith's first visit? */
SELECT vets.name as vet,animals.name as "First Animal", visits.date_of_visit FROM vets INNER JOIN visits ON vets.id = visits.vets_id
INNER JOIN animals on animals.id=visits.animals_id WHERE vets.name = 'Maisy Smith' ORDER BY visits.date_of_visit ASC LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT animals.*, vets.*, visits.date_of_visit FROM animals JOIN visits on animals.id = visits.animals_id
JOIN vets ON vets_id = visits.vets_id ORDER BY visits.date_of_visit DESC LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT name, COUNT(*) as "No. Of Visits" FROM vets JOIN visits ON vets.id = visits.vets_id
WHERE vets.id NOT IN (
  SELECT vets_id from specializations
) GROUP BY name;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT species.name, COUNT(visits.animals_id) FROM visits JOIN vets ON vets.id = visits.vets_id
JOIN animals ON visits.animals_id = animals.id 
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith' GROUP BY species.name ORDER BY count DESC LIMIT 1;
